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
    
    var delegate: ContactsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "ShowNewContactViewController" {
            guard let destVC = segue.destination as? NewContactViewController else { return }
            guard let tableCell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: tableCell) else { return }
            destVC.delegate = self
            let key = Array(DataManager.instance.dataSource.keys)[indexPath.section]
            guard let contact = DataManager.instance.dataSource[key]?[indexPath.row] else { return }
            destVC.contacts = contact
            destVC.source = .add
        } else if identifier == "ShowEditViewController" {
            guard let destVC = segue.destination as? NewContactViewController else { return }
            guard let tableCell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: tableCell) else { return }
            destVC.delegate = self
            let key = Array(DataManager.instance.dataSource.keys)[indexPath.section]
            guard let contact = DataManager.instance.dataSource[key]?[indexPath.row] else { return }
            destVC.contacts = contact
            destVC.source = .edit
        }
    }
    
    
    @IBAction func addNewContact(_ sender: Any) {
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
        DataManager.instance.dataSource.keys.
    }
}

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }
        let key = Array(DataManager.instance.dataSource.keys)[indexPath.section]
        
        guard let contact = DataManager.instance.dataSource[key]?[indexPath.row] else { return UITableViewCell() }
        cell.update(contact: contact.fullName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(DataManager.instance.dataSource.keys)[section]
        return DataManager.instance.dataSource[key]?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let key = Array(DataManager.instance.dataSource.keys)[indexPath.section]
            guard let contact = DataManager.instance.dataSource[key]?[indexPath.row] else { return }
            DataManager.instance.delete(contact)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let firstLetterSurnameContact = Array(DataManager.instance.dataSource.keys)[section]
        return firstLetterSurnameContact
    }
}

extension ContactsViewController {
    enum Source {
        case add
        case edit
    }
}

extension ContactsViewController: ContactsDelegate {
    func didResetInfo() {
        tableView.reloadData()
    }
}
