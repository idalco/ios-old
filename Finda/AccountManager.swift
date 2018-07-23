//
//  AccountManager.swift
//  Finda
//

import Foundation
import UIKit

final class AccountManager {
    fileprivate var dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        
        fetchCurrentUser()
    }
    
    // data models
    fileprivate(set) var currentUser: User?
}

extension AccountManager {
    //    MARK:- Public API
    //    These methods should be custom tailored to read specific data subsets,
    //    as required for specific views. These will be called by Coordinators,
    //    then routed into UIViewControllers
    
    func currentUser(callback: @escaping (User?, Error?) -> Void) {
        callback(currentUser, nil)
        
        fetchCurrentUser() {
            [unowned self] _, dataError in
            if let dataError = dataError {
                callback( self.currentUser, dataError )
                return
            }
            callback( self.currentUser, nil )
            return
        }
    }
    
    func userLoggedIn() {
        fetchCurrentUser()
    }
    
    func userLoggedOut() {
        currentUser = nil
    }
    
    func updateUserSettings(user: User, sender: Any?, completion: @escaping (Error?) -> Void) {
    }
    
    func updateUserProfile(user: User, sender: Any?, completion: @escaping (Error?) -> Void) {
        dataManager.saveProfile(user: user, callback: completion)
    }
    
    func updateAvatar(avatar: UIImage, sender: Any?, completion: @escaping (Error?) -> Void) {
        dataManager.saveAvatar(avatar: avatar, callback: completion)
    }
}


fileprivate extension AccountManager {
    //    MARK:- Private API
    //    These are thin wrappers around DataManager‘s similarly named methods.
    //    They are used to process received data and splice and dice them as needed,
    //    into business logic that only CatalogManager knows about
    
    func fetchCurrentUser(callback: @escaping (Bool, Error?) -> Void = {_,_ in}) {
        dataManager.fetchCurrentUser(callback: { (user, error) in
            if user != nil {
                self.currentUser = user
                callback(true, nil)
            }
            else
            {
                callback(false, error)
            }
        })
    }
}

