//
//  ContactDetailsViewController.swift
//  ContactManager
//
//  Created by Siju Satheesachandran on 16/03/2020.
//  Copyright © 2020 Siju Satheesachandran. All rights reserved.
//

import UIKit




class ContactDetailsViewController: UITableViewController {

    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    var detailsViewModel: ContactViewModel!
    var contactDataManager:ContactDataManager!
    var editAndSaveContact: ContactAddAction?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        // Do any additional setup after loading the view.
    }
    
    class func initController(viewModel: ContactViewModel? = nil) -> ContactDetailsViewController{
        
        let viewController:ContactDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailsViewController")  as! ContactDetailsViewController
        viewController.detailsViewModel = viewModel
        return viewController
        
    }
    func configureView() {
        configureNavigationItems()

        profilePictureView.image = detailsViewModel.contactImage
        nameLabel.attributedText = detailsViewModel.contactName
        phoneNumberLabel.text = detailsViewModel.contactPhoneNumber

    }
    
    func configureNavigationItems() {
        let rightButton =  UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editContact))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func editContact() {
      DispatchQueue.main.async {
        let addEditVC = ContactEditViewController.initController(viewModel: self.detailsViewModel)
          addEditVC.editAndSaveContact = { [weak self](contact) in
              guard let weakSelf = self else { return }
              ContactDataService.shared.updateContact(contact: contact)
              weakSelf.resetContactDetailViewModelWith(viewModel: ContactViewModel(contactData: contact))
              weakSelf.contactDataManager.updateContact(updatedContact: contact)
          }
          self.navigationController?.pushViewController(addEditVC, animated: true)
      }
    }
    
    func resetContactDetailViewModelWith(viewModel: ContactViewModel) {
        detailsViewModel = viewModel
        DispatchQueue.main.async {
            self.configureView()
        }
    }
    
    @IBAction func call(_ sender: Any) {
       
        if let url = URL(string: "tel://\(detailsViewModel.contactPhoneNumber)"),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
      
    }
    
    
 /*   func resetContactDetailViewModelWith(viewModel: ContactDetailViewModel) {
        detailsViewModel = viewModel
        DispatchQueue.main.async {
            self.configureView()
        }
    }
    
    func configureNavigationItems() {
     //   flowCoordinator = ContactDetailFlowCoordinator(parent: self)
        let rightButton =  UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editContact))
        navigationItem.rightBarButtonItem = rightButton
    } */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }

}
