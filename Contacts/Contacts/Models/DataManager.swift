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
    
    private (set) var dataSource: [String: [Contact]] = [:]
    private (set) var lettersArray: [String] = []
    var allContacts: [Contact] = []
    
    private func generateMock() {
        let firstContact  = Contact(name: "Max", surname: "Nestertov", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "1")!)
        let secodContact  = Contact(name: "Dima", surname: "Nestertov", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "2")!)
        let thirdContact  = Contact(name: "Petr", surname: "Pupa", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "3")!)
        let fouthContact  = Contact(name: "Kostya", surname: "Lenivikys", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "4")!)
        let fifthContact  = Contact(name: "Egor", surname: "Kolbasov", email: "max@gmail.com", phoneNumber: "0222222", image: UIImage(named: "5")!)
        let mock = [firstContact, secodContact, thirdContact, fouthContact, fifthContact]
        
        allContacts.append(contentsOf: mock)
        compileDataBase()
    }
    
    func compileDataBase() {
        for item in allContacts {
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
        updateLettersArray()
    }
    
    func updateLettersArray() {
        lettersArray = Array(dataSource.keys)
        lettersArray.sort()
    }
    
    func getContact(indexPath: IndexPath) -> Contact? {
        let contactKey = lettersArray[indexPath.section]
        let contactsForSection = dataSource[contactKey]
        return contactsForSection?[indexPath.row]
    }

    func addContact(_ contact: Contact) {
        allContacts.append(contact)
        resetDataSource()
        updateLettersArray()
        NotificationCenter.default.post(name: .ContactAdded, object: nil)
    }
    
    func resetDataSource() {
        dataSource = [:]
        compileDataBase()
    }
    
     func delete(_ contact: Contact) {
         guard let deletingIndex = getIndex(of: contact, in: allContacts) else { return }
         allContacts.remove(at: deletingIndex)
         resetDataSource()
         updateLettersArray()
         NotificationCenter.default.post(name: .ContactDeleted, object: nil)
         }
    
    func editContact(_ contact: Contact) {
        guard let editingIndex = getIndex(of: contact, in: allContacts) else { fatalError("Contact index is lost") }
        allContacts[editingIndex] = contact
        resetDataSource()
        updateLettersArray()
        NotificationCenter.default.post(name: .ContactChanged, object: nil)
    }
    
    func getIndex(of contact: Contact, in contactsArray: [Contact]) -> Int? {
        var contactIndex: Int?
        for (index, item) in contactsArray.enumerated() where item.id == contact.id {
            contactIndex = index
            break
        }
        return contactIndex
    }
}
