//
//  CurrentUser.swift
//  Finda
//

import Foundation
import UIKit

final class CurrentUser {
    
    let firstName: String
    let lastName: String
    var avatar: String?
    
    var avatarImage: UIImage?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init(user: User) {
        self.firstName = user.firstName
        self.lastName = user.lastName
    }
}
