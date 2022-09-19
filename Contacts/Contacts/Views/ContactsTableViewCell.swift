//
//  ContactsTableViewCell.swift
//  Contacts
//
//  Created by M1 on 17.09.2022.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet var personName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func update(contact: String) {
        personName.text = contact
    }
}
