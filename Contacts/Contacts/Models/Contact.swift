//
//  Contact.swift
//  Contacts
//
//  Created by M1 on 17.09.2022.
//

import Foundation
import UIKit

struct Contact: Equatable {
    let name: String
    let surname: String
    let email: String
    let phoneNumber: String
    let image: UIImage
    var id: UUID = UUID()
    var fullName: String {
        surname + " " + name
    }
    
    static func == (left: Contact, right: Contact) -> Bool {
        return true
    }
}
