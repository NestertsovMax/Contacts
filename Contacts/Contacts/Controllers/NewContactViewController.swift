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
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editContactData()
        circleImageChanger()
        switch source {
        case .add:
            imageContact.image = UIImage(named: "user")
            addEditContactButton.title = "Добавить"
            title = "Создать"
        case .edit:
            addEditContactButton.title = "Записать"
            title = "Редактировать"
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    func circleImageChanger() {
        imageContact?.layer.cornerRadius = (imageContact?.frame.size.width ?? 0.0) / 2
        imageContact?.clipsToBounds = true
        imageContact?.layer.borderWidth = 3.0
        imageContact?.layer.borderColor = UIColor.white.cgColor
    }
    
    func editContactData() {
        imageContact.image = contacts?.image
        name.text = contacts?.name
        surname.text = contacts?.surname
        email.text = contacts?.email
        phoneNumber.text = contacts?.phoneNumber
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Camare is not available", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func addEditContactButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Ошибка!", message: "Заполните поля Имя и Фамилия", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        let alertEmail = UIAlertController(title: "Не соответствует почта!", message: "Введите коректно почту!", preferredStyle: .alert)
        alertEmail.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        guard let name = name.text, !name.isEmpty else { return self.present(alert, animated: true) }
        guard let surname = surname.text, !surname.isEmpty else { return self.present(alert, animated: true) }
        var email = email.text ?? ""
        if !email.isEmpty, !email.contains("@") {
            self.present(alertEmail, animated: true)
        } else { email = "" }
        let phoneNumber = phoneNumber.text ?? ""
        guard let imageContact = imageContact.image else { return }
        switch source {
        case .add:
            let newContact = Contact(name: name, surname: surname, email: email, phoneNumber: phoneNumber, image: imageContact)
            DataManager.instance.addContact(newContact)
        case .edit:
            guard let id = contacts?.id else { return }
            let editContact = Contact(name: name, surname: surname, email: email, phoneNumber: phoneNumber, image: imageContact, id: id)
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
        
        if let image = info [UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageContact.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol ContactsDelegate: AnyObject {
    func didResetInfo()
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
