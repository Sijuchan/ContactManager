//
//  ContactTableViewCell.swift
//  ContactManager
//
//  Created by Siju Satheesachandran on 10/03/2020.
//  Copyright © 2020 Siju Satheesachandran. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    var viewModel: ContactViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populateViewWithViewModel(viewModel: ContactViewModel) {
        self.viewModel = viewModel
        self.textLabel?.attributedText = viewModel.contactName
        self.detailTextLabel?.text = viewModel.contactPhoneNumber
        self.imageView?.image = viewModel.contactImage
    
    }
}
