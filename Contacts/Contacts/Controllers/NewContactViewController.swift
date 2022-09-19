//
//  NewContactViewController.swift
//  Contacts
//
//  Created by M1 on 17.09.2022.
//

import UIKit

class NewContactViewController: UIViewController {

    @IBOutlet var imageContact: UIImageView!
    @IBOutlet var name: UITextField!
    @IBOutlet var surname: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var addEditContactButton: UIBarButtonItem!
    
    var contacts: Contact?
    var source: Source = .add
    var currentImage: UIImage?
    var imagePicker = UIImagePickerController()
    var delegate: ContactsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editContactData()
        circleImageChanger()
        switch source {
        case .add:
            addEditContactButton.title = "Добавить"
            title = "Создать"
        case .edit:
            addEditContactButton.title = "Записать"
            title = "Редактировать"
        }
        
        
    }
    
    func circleImageChanger() {
        imagePicker.delegate = self
        imageContact.layer.borderWidth = 1
        imageContact.layer.masksToBounds = false
        imageContact.layer.borderColor = UIColor.black.cgColor
        imageContact.layer.cornerRadius = imageContact.frame.height/2
        imageContact.clipsToBounds = true
    }
    
    func editContactData() {
        imageContact.image = contacts?.image
        name.text = contacts?.name
        surname.text = contacts?.surname
        email.text = contacts?.email
        phoneNumber.text = contacts?.phoneNumber
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addEditContactButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Ошибка!", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        guard let name = name.text, !name.isEmpty else { return self.present(alert, animated: true) }
        guard let surname = surname.text, !surname.isEmpty else { return self.present(alert, animated: true) }
        guard let email = email.text else { return }
        guard let phoneNumber = phoneNumber.text else { return }
        guard let imageContact = imageContact.image else { return }
        switch source {
        case .add:
            let newContact = Contact(name: name, surname: surname, email: email, phoneNumber: phoneNumber, image: imageContact)
            DataManager.instance.addContact(newContact)
        case .edit:
            let editContact = Contact(name: name, surname: surname, email: email, phoneNumber: phoneNumber, image: imageContact)
            DataManager.instance.editContact(editContact)
        }
        navigationController?.popToRootViewController(animated: true)
    }
}

extension NewContactViewController {
    enum Source {
        case add
        case edit
    }
}

extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageContact.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

protocol ContactsDelegate: AnyObject {
    func didResetInfo()
}
