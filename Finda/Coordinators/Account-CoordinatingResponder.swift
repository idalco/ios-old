//
//  Account-CoordinatingResponder.swift
//  Finda
//

import Foundation
import UIKit

final class AccountPageBox: NSObject {
    let unbox: AccountCoordinator.Page
    init(_ value: AccountCoordinator.Page) {
        self.unbox = value
    }
}
extension AccountCoordinator.Page {
    var boxed: AccountPageBox { return AccountPageBox(self) }
}


extension UIResponder {
    
    //    ** Data requests by various VCs should bubble up to some of the Coordinators
    //    ** which will then contact DataManager, get the data and pass it back
    
    /// Returns the list of all currently promoted products
    ///
    /// - Parameters:
    ///   - sender: reference to object who requested data
    ///   - feedback: user's feedback to send
    ///   - completion: Closure to call when data is ready or error occurs
    
    @objc dynamic func dismissLoginRegister(sender: Any?) {
        coordinatingResponder?.dismissLoginRegister(sender: sender)
    }
    
    @objc dynamic func updateUserProfile(user: User, sender: Any?, completion: @escaping (Error?) -> Void) {
        coordinatingResponder?.updateUserProfile(user: user, sender: sender, completion: completion)
    }
    
    @objc dynamic func updateUserSettings(user: User, sender: Any?, completion: @escaping (Error?) -> Void) {
        coordinatingResponder?.updateUserSettings(user: user, sender: sender, completion: completion)
    }
    
    @objc dynamic func updateAvatar(avatar: UIImage, sender: Any?, completion: @escaping (Error?) -> Void) {
        coordinatingResponder?.updateAvatar(avatar: avatar, sender: sender, completion: completion)
    }

    @objc dynamic func loginWithCredentials(sender: Any?, email: String, password: String, completion: @escaping (Bool) -> Void) {
        coordinatingResponder?.loginWithCredentials(sender: sender, email: email, password: password, completion: completion)
    }
    
    // TODO: find some way of fixing this (provider) so we can use proper enum
    @objc dynamic func loginWithCredentialsAndProvider(sender: Any?, email: String, password: String, provider: String, completion: @escaping (Bool) -> Void) {
        coordinatingResponder?.loginWithCredentials(sender: sender, email: email, password: password, completion: completion)
    }
    
    @objc dynamic func logout(sender: Any?) {
        coordinatingResponder?.logout(sender: sender)
    }
    
    @objc dynamic func registerWithCredentials(sender: Any?, name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        coordinatingResponder?.registerWithCredentials(sender: sender, name: name, email: email, password: password, completion: completion)
    }
    
    @objc dynamic func fetchCurrentUser(sender: Any?, completion: @escaping (User?, Error?) -> Void) {
        coordinatingResponder?.fetchCurrentUser(sender: sender, completion: completion)
    }
    
    
}
