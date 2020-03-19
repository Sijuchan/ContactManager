//
//  ContactEditViewController.swift
//  ContactManager
//
//  Created by Siju Satheesachandran on 15/03/2020.
//  Copyright © 2020 Siju Satheesachandran. All rights reserved.
//

import UIKit
import Contacts
public typealias ContactAddAction = (_ contact: CNMutableContact) -> Void

enum AddEditMode {
    case add
    case edit
}

class ContactEditViewController: UITableViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    var detailsViewModel: ContactViewModel?
    var addContact: ContactAddAction?
    var editAndSaveContact: ContactAddAction?
    var addEditMode: AddEditMode = .add
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    class func initController(viewModel: ContactViewModel? = nil) -> ContactEditViewController{
        let viewController:ContactEditViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactEditViewController")  as! ContactEditViewController
        viewController.detailsViewModel = viewModel
        return viewController
    }
    
    func configureViewController() {
         addEditMode = (detailsViewModel != nil) ? AddEditMode.edit : AddEditMode.add
         configureNavigationItems()
     }
     
     func configureNavigationItems() {
         let rightButton: UIBarButtonItem!
         if addEditMode == .add {
             rightButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addContactAction))
         } else {
             rightButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editContactAction))
             configureWithContact()
         }
         navigationItem.rightBarButtonItem = rightButton
     }
     
     func configureWithContact() {
        firstNameField.text = detailsViewModel?.contact.givenName
         lastNameField.text =  detailsViewModel?.contact.familyName
         phoneNumberField.text =  detailsViewModel?.contactPhoneNumber

     }
     
     @objc func addContactAction() {
         if isValidInput {
             addContact?(updatedContact())
             self.navigationController?.popViewController(animated: true)
         } else {
             invalidInputDataError()
         }
     }
     
      @objc func editContactAction() {
         if isValidInput {
             editAndSaveContact?(updatedContact())
             self.navigationController?.popViewController(animated: true)
         } else {
             invalidInputDataError()
         }
     }
     
     func updatedContact() -> CNMutableContact {
          var createContact = CNMutableContact()
         if let theContact =  detailsViewModel?.contact, let mutableCopy = theContact.mutableCopy() as? CNMutableContact {
             createContact = mutableCopy
         }
        createContact.givenName = firstNameField.text!
        createContact.familyName = lastNameField.text!
        createContact.phoneNumbers = [CNLabeledValue(label: "Mobile", value: CNPhoneNumber(stringValue: phoneNumberField.text!))]

         return createContact
     }
    
     var isValidInput: Bool {
          return (firstNameField.text != nil) && (phoneNumberField.text != nil)
     }
     
     func invalidInputDataError() {
         DispatchQueue.main.async {
            let alert = UIAlertController(title: "Invalid Data", message: "First-name and Phone-number both are mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
         }
     }
    

}
