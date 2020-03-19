//
//  ContactDataService.swift
//  ContactManager
//
//  Created by Siju Satheesachandran on 10/03/2020.
//  Copyright © 2020 Siju Satheesachandran. All rights reserved.
//

import UIKit
import Contacts

public typealias ContactDataCompletion = (_ contacts: [CNContact], _ error: Error?) -> Void
public typealias ContactAuthCompletion = (_ sucess: Bool, _ error: Error?) -> Void

class ContactDataService {
    
    static let shared = ContactDataService()
    let contactStore = CNContactStore()
    var contactResult: [CNContact] = []
    
    private init(){ }
    
    func requestToAccesTheContact(completion: ContactAuthCompletion?) {
        contactStore.requestAccess(for: .contacts) { [weak self](sucess, error) in
            guard let weakSelf = self else { return }
            weakSelf.isAuthorized()
            completion?(sucess, error)
        }
    }
    
    @discardableResult func isAuthorized() -> Bool{
        return CNContactStore.authorizationStatus(for: .contacts) == .authorized
    }
    
    func getAllContactsWithCompletion(completion: ContactDataCompletion?) {
        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor])
        fetchRequest.sortOrder = CNContactSortOrder.userDefault
        
        do {
            var resultsSet = [CNContact]()
            try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                resultsSet.append(contact)
            })
            contactResult = resultsSet
            completion?(resultsSet, nil)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            completion?([], error)
        }
    }
    
    @discardableResult func addNewContact(contact: CNMutableContact) -> CNContact? {
        
        var createdNewContact: CNContact?
        let saveRequest: CNSaveRequest = CNSaveRequest()
        
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        do {
            try ContactDataService.shared.contactStore.execute(saveRequest)
            createdNewContact = contact
            contactResult.append(contact)
        }
        catch {
            let err = error as! CNError
            print("createdNewContact : Failure \(err)")
        }
        
        return createdNewContact
    }
    
    func deleteContact(contact: CNContact) {
        let contactToDelete:CNMutableContact = contact.mutableCopy() as! CNMutableContact
        let saveRequest: CNSaveRequest = CNSaveRequest()
        saveRequest.delete(contactToDelete)
        do {
            try ContactDataService.shared.contactStore.execute(saveRequest)
            contactResult = contactResult.filter({ (contactItem) -> Bool in
                return contactItem.identifier != contact.identifier
            })
        }
        catch {
            let err = error as! CNError
            print("deleteContact : Failure \(err)")
        }
    }
    
    func updateContact(contact: CNMutableContact) {
        let saveRequest: CNSaveRequest = CNSaveRequest()
        saveRequest.update(contact)
        do {
            try ContactDataService.shared.contactStore.execute(saveRequest)
            contactResult = contactResult.map({ (contactItem) -> CNContact in
                return (contactItem.identifier == contact.identifier) ? contact : contactItem
            })
        }
        catch {
            let err = error as! CNError
            print("updateContact : Failure \(err)")
        }
    }
}
