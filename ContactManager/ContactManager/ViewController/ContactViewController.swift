//
//  ContactViewController.swift
//  ContactManager
//
//  Created by Siju Satheesachandran on 10/03/2020.
//  Copyright © 2020 Siju Satheesachandran. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactTableView: UITableView!
    var addNewContact: UIBarButtonItem!
    var contactDataManager = ContactDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.delegate = self
        contactTableView.dataSource = self
        reloadObserverToDataSource()
        setConfiguration()
    }
    
    func setConfiguration() {
        contactDataManager.requestAccesContacts()
        loadContacts()
        configureNavigationItems()
    }
    
    func reloadObserverToDataSource() {
        contactDataManager.dataCompletion = { [weak self](needsReload) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.contactTableView.reloadData()
            }
        }
    }
    
    func configureNavigationItems() {
        addNewContact = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContactAction))
        navigationItem.rightBarButtonItem = addNewContact
        navigationItem.rightBarButtonItem = addNewContact
    }
    
    @objc func addNewContactAction() {
        DispatchQueue.main.async {
            let addVC = ContactEditViewController.initController()
            addVC.addContact = { (mutableContact) in
                _ = self.contactDataManager.addContactWith(contact: mutableContact)
            }
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    func loadContacts() {
        DispatchQueue.main.async {
            self.contactTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactDataManager.sameFirstLetters[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  ["A", "B", "C", "D", "E", "F","G", "H", "I", "J", "K", "L","M", "N", "O", "P", "Q", "R","S", "T", "U", "V", "W", "X", "Y" ,"Z", "#"]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactDataManager.contactsSectionedViewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactDataManager.contactsSectionedViewModel[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        
        let viewModel = contactDataManager.contactsSectionedViewModel[indexPath.section][indexPath.row]
        cell.populateViewWithViewModel(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewModel = contactDataManager.contactsSectionedViewModel[indexPath.section][indexPath.row]
        DispatchQueue.main.async {
            let addEditVC = ContactDetailsViewController.initController()
            addEditVC.detailsViewModel = viewModel
            addEditVC.contactDataManager = self.contactDataManager
            self.navigationController?.pushViewController(addEditVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
          contactDataManager.deleteContactAtIndexPath(indexPath: indexPath)

        }
    }
}


