//
//  DataManager.swift
//  Contacts
//
//  Created by M1 on 18.09.2022.
//

import Foundation
import UIKit

final class DataManager {
    static let instance = DataManager()
    private init() {}
    
    private(set) var contacts: [Contact] = []
    
    func addContact(_ contact: Contact) {
        contacts.insert(contact, at: 0)
    }
    
    func deleteContact(_ index: Int) {
        self.contacts.remove(at: index)
    }
    
    func editContact(_ contact: Contact) {
        guard let editingContactIndex = contacts.firstIndex(where: { $0.id == contact.id } ) else { return }
        contacts.remove(at: editingContactIndex)
        contacts.append(contact)
        contacts = contacts.sorted(by: { $0.surname < $1.surname })
        
        print(contacts)
    }
    
}
