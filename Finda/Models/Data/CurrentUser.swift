//
//  CurrentUser.swift
//  Finda
//

import Foundation
import UIKit

final class CurrentUser {
    
    let id: Int
    let firstName: String
    let lastName: String
    var avatar: String?
    
    var avatarImage: UIImage?
    
    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init(user: User) {
        self.id = user.id
        self.firstName = user.firstName
        self.lastName = user.lastName
    }
}
