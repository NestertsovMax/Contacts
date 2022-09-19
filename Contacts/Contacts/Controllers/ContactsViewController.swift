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
            destVC.contacts = DataManager.instance.contacts[indexPath.row]
            destVC.source = .add
        } else if identifier == "ShowEditViewController" {
            guard let destVC = segue.destination as? NewContactViewController else { return }
            guard let tableCell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: tableCell) else { return }
            destVC.contacts = DataManager.instance.contacts[indexPath.section]
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
}

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }
        let contact = DataManager.instance.contacts[indexPath.row]
        cell.update(contact: contact.surname)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataManager.instance.contacts.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.instance.deleteContact(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ContactsViewController: ContactsDelegate {
    func didResetInfo() {
        tableView.reloadData()
    }
}

extension ContactsViewController {
    enum Source {
        case add
        case edit
    }
}
