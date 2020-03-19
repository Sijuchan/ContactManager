//
//  ContactViewModel.swift
//  ContactManager
//
//  Created by Siju Satheesachandran on 10/03/2020.
//  Copyright © 2020 Siju Satheesachandran. All rights reserved.
//

import UIKit
import Contacts

@objc protocol ContactModel {
    var contactPhoneNumber: String { get }
    var contactName: NSAttributedString { get }
    var contactImage: UIImage { get }
}

class ContactViewModel: ContactModel {

    internal let contact: CNContact
    
    init(contactData: CNContact) {
        contact = contactData
    }
    var contactName: NSAttributedString {
        let attrString = NSMutableAttributedString(string: contact.givenName,
                                                   attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)])
        
        attrString.append(NSMutableAttributedString(string: " " + contact.familyName,
                                                    attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)]))
        return attrString
    }


    
    var contactPhoneNumber: String {
        return contact.phoneNumbers.first?.value.stringValue ?? ""
    }
    
    var contactImage: UIImage {
        var image: UIImage = UIImage(named: "unknown_dp")!
        if contact.imageDataAvailable {
            if let imageData = contact.thumbnailImageData ,let theImage = UIImage(data: imageData) {
                image = theImage
            }
        }
        return image
    }


}
