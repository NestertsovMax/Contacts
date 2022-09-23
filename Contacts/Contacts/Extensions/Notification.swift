//
//  Notification.swift
//  Contacts
//
//  Created by M1 on 22.09.2022.
//

import Foundation

extension Notification.Name {
    static var ContactAdded = Notification.Name("ContactAdded")
    static var ContactChanged = Notification.Name("ContactChanged")
    static let ContactDeleted = Notification.Name("ContactDeleted")
}
