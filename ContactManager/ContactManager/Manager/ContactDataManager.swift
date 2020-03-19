//
//  ContactDataManager.swift
//  ContactManager
//
//  Created by Siju Satheesachandran on 10/03/2020.
//  Copyright © 2020 Siju Satheesachandran. All rights reserved.
//

import UIKit
import Contacts

public typealias DataFetchTableReloadCompletion = (_ tableNeedsReload: Bool) -> Void

class ContactDataManager: NSObject {
    
     var allContactResults: [CNContact] = []
     var contactsSectionedViewModel = [[ContactViewModel]]()
     var sameFirstLetters = [String]()
     var dataCompletion: DataFetchTableReloadCompletion?
    
    func requestAccesContacts() {
        ContactDataService.shared.requestToAccesTheContact { [weak self](success, error) in
            guard let weakSelf = self else { return }
            if success {
                weakSelf.getAllContact()
            }
        }
    }
    fileprivate  func getAllContact() {
        ContactDataService.shared.getAllContactsWithCompletion { [weak self](results, error) in
            guard let weakSelf = self else { return }
            weakSelf.allContactResults.append(contentsOf: results)
            weakSelf.updateContactSource()
        }
    }
    
    private func updateContactSource() {

         setSameFirstLetters()
         setSectionedContacts()
         dataCompletion?(true)
     }
    
    @discardableResult func addContactWith(contact: CNMutableContact) -> CNContact? {
        var addedCon: CNContact?
        if let theContact =  ContactDataService.shared.addNewContact(contact: contact) {
            allContactResults.append(theContact)
            addedCon = theContact
            updateContactSource()
            dataCompletion?(true)
        }
        return addedCon
    }
    
     func deleteContactAtIndexPath(indexPath: IndexPath) {
          let viewModel = contactsSectionedViewModel[indexPath.section][indexPath.row]
         let contactToDelete = viewModel.contact
         allContactResults = allContactResults.filter { (contact) -> Bool in
             contactToDelete != contact
         }
         ContactDataService.shared.deleteContact(contact: contactToDelete)
          updateContactSource()
     }
     
     func updateContact(updatedContact: CNContact) {
         allContactResults = allContactResults.map({ (contact) -> CNContact in
              return (updatedContact.identifier == contact.identifier) ? updatedContact : contact
         })
         updateContactSource()
     }
}


extension ContactDataManager {
    
    func setSameFirstLetters() {
        let firstLetters = allContactResults.map { $0.firstLetterForSort }
        let uniqueFirstLettersData = Set(firstLetters)
        sameFirstLetters = Array(uniqueFirstLettersData).sorted()
    }
    
    func setSectionedContacts() {
        contactsSectionedViewModel = sameFirstLetters.map { firstLetter in
            let filteredContact = allContactResults.compactMap{ ($0.firstLetterForSort == firstLetter) ?  ContactViewModel(contactData: $0) : nil }
            return filteredContact.sorted(by: { $0.contactPhoneNumber < $1.contactPhoneNumber })
        }
    }
    
}

extension CNContact {
    var firstLetterForSort: String {
        if givenName.count > 0 {
            return String(givenName.first!).uppercased()
        } else {
            return ""
        }
    }
}
