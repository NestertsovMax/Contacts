//
//  ContactsViewController.swift
//  Contacts
//
//  Created by M1 on 17.09.2022.
//

import UIKit

class ContactsViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var contactSearch: UISearchBar!
    
    private var isSearchActive: Bool = false
    private var filteredContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        tableView.delegate = self
        tableView.dataSource = self
        contactSearch.delegate = self
        addObservers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "addContact" {
            guard let destVC = segue.destination as? NewContactViewController else { return }
            guard let tableCell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: tableCell) else { return }
            let key = Array(DataManager.instance.dataSource.keys)[indexPath.section]
            guard let contact = DataManager.instance.dataSource[key]?[indexPath.row] else { return }
            destVC.contacts = contact
            destVC.source = .add
        } else if identifier == "ShowNewContactViewController" {
            guard let destVC = segue.destination as? NewContactViewController else { return }
            guard let tableCell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: tableCell) else { return }
            let key = DataManager.instance.lettersArray[indexPath.section]
            guard let contact = DataManager.instance.dataSource[key]?[indexPath.row] else { return }
            destVC.contacts = contact
            destVC.source = .edit
        }
    }
    
    
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(contactDeleted), name: .ContactDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactDetailsChanged), name: .ContactChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactAdded), name: .ContactAdded, object: nil)
    }
    
        @objc func contactDetailsChanged() {
            DataManager.instance.resetDataSource()
            updateSearchArrayIfNeeded()
            tableView.reloadData()
        }
        
        @objc func contactAdded() {
            tableView.reloadData()
        }
        
        @objc func contactDeleted() {
            updateSearchArrayIfNeeded()
            tableView.reloadData()
        }
    
    private func updateSearchArrayIfNeeded() {
        guard isSearchActive else { return }
        let searchText = contactSearch.text ?? ""
        filterContacts(byName: searchText)
    }
    
    @IBAction func addNewContact(_ sender: Any) {
    }
    
    private func filterContacts(byName name: String) {
        isSearchActive = !name.isEmpty
        filteredContacts.removeAll()
        for contact in DataManager.instance.allContacts {
            if contact.fullName.lowercased().contains(name.lowercased()) {
                filteredContacts.append(contact)
            }
        }
        tableView.reloadData()
    }
    
    private func getContact(for indexPath: IndexPath) -> Contact {
        let contact: Contact
        if isSearchActive {
            contact = filteredContacts[indexPath.row]
        } else {
            guard let loadContact = DataManager.instance.getContact(indexPath: indexPath) else { fatalError ("Contact wrong indexPath")}
            contact = loadContact
        }
        return contact
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchActive ? 1 : DataManager.instance.lettersArray.count
    }
}

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }
        let key = DataManager.instance.lettersArray[indexPath.section]
        let contactsByLetter = DataManager.instance.dataSource[key] ?? []
        let contact = isSearchActive ? filteredContacts[indexPath.row] : contactsByLetter[indexPath.row]
        cell.update(contact: contact.fullName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = DataManager.instance.lettersArray[section]
        let contactsByLetter = DataManager.instance.dataSource[key] ?? []
        return isSearchActive ? filteredContacts.count : contactsByLetter.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = getContact(for: indexPath)
        DataManager.instance.delete(item)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchActive ? "Search" : DataManager.instance.lettersArray[section]
    }
}

extension ContactsViewController {
    enum Source {
        case add
        case edit
    }
}



extension ContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContacts(byName: searchText)
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            view.endEditing(true)
    }
}
