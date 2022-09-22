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
    
    private init() {
        generateMock()
    }
    
    private(set) var dataSource: [String: [Contact]] = [:]
    
    private func generateMock() {
        let firstContact  = Contact(name: "Max", surname: "Nestertov", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "1")!)
        let secodContact  = Contact(name: "Dima", surname: "Nestertov", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "2")!)
        let thirdContact  = Contact(name: "Petr", surname: "Pupa", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "3")!)
        let fouthContact  = Contact(name: "Kostya", surname: "Lenivikys", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "4")!)
        let fifthContact  = Contact(name: "Egor", surname: "Kolbasov", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "5")!)
        let mock = [firstContact, secodContact, thirdContact, fouthContact, fifthContact]
        
        for item in mock {
            if var currentValue = dataSource[item.surnameFirstLetter] {
                currentValue.append(item)
                dataSource.updateValue(currentValue, forKey: item.surnameFirstLetter)
            } else {
                dataSource.updateValue([item], forKey: item.surnameFirstLetter)
            }
        }

        for (key, element) in dataSource {
            let sortedValue = element.sorted(by: { $0.name < $1.name })
            dataSource[key] = sortedValue
        }
    }

    
    func addContact(_ contact: Contact) {
        if var currentValue = dataSource[contact.surnameFirstLetter] {
            currentValue.append(contact)
            dataSource.updateValue(currentValue, forKey: contact.surnameFirstLetter)
        } else {
            dataSource.updateValue([contact], forKey: contact.surnameFirstLetter)
        }
    }
    
     func delete(_ contact: Contact) {
         guard var contacts = dataSource[contact.surnameFirstLetter],
         let index = contacts.firstIndex(where: {
             $0.id == contact.id
         })
         else { return }
         contacts.remove(at: index)
         if contacts.isEmpty {
             dataSource[contact.surnameFirstLetter] = nil
         } else {
             dataSource.updateValue(contacts, forKey: contact.surnameFirstLetter)
         }
    }
    
    func editContact(_ contact: Contact) {
        guard var contacts = dataSource[contact.surnameFirstLetter],
        let index = contacts.firstIndex(where: {
            $0.id == contact.id
        })
        else { return }
        contacts.remove(at: index)
        dataSource.updateValue(contacts, forKey: contact.surnameFirstLetter)
        addContact(contact)
    }
}
