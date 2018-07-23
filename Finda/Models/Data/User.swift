//
//  User.swift
//  Finda
//

import Foundation
import Marshal

final class User: NSObject, Unmarshaling {
    let id: Int
    var firstName: String
    var lastName: String
    var email: String
    var avatar: String
    let created: String?
    var currencyCode: String
    var locale: String
    var avatarBitmapB64: String?
    var avatarImage: UIImage?
    var usertype: Int
    var instagramUsername: String?
    
    init(id: Int, firstName: String, lastName: String, email: String, avatar: String, created: String, currencyCode: String, locale: String, usertype: Int, instagramUsername: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.avatar = avatar
        self.created = created
        self.currencyCode = currencyCode
        self.locale = locale
        self.usertype = usertype
        self.instagramUsername = instagramUsername

    }
    
    init(object: MarshaledObject) throws {
        id = try Int(object.value(for: "id") as String)!
        firstName = try object.value(for: "name")
        lastName = try object.value(for: "surname")
        email = try object.value(for: "mail")
        avatar = try object.value(for: "avatar")
        created = try object.value(for: "created")
        currencyCode = try object.value(for: "currencyCode")
        locale = try object.value(for: "locale")
        usertype = try object.value(for: "usertype")
        instagramUsername = try object.value(for: "instagram_username")
        
    }    
}
