//
//  LoginManager.swift
//  Finda
//
//  Created by Peter Lloyd on 25/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class LoginManager {
    
    enum LoginStatus: Int {
        case Unverified = 0
        case verified = 1
        case Banned = 2
        case Special = 99
    }
    
    func login(email: String, password: String, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .login(email: email, password: password)) { (response, result) in
            if(response){
                _ = ModelManager(data: result)
                let defaults = UserDefaults.standard
                defaults.set(result["userdata"]["token"].string, forKey: "access_token_auth")
                completion(response, result)
            }
            completion(false, result)
        }
    }
    
    
    static func signOut(){
        CoreDataManager.deleteAllData(entity: "User")
        CoreDataManager.deleteAllData(entity: "Profile")
        
        FindaAPISession(target: .logout()) { (_, _) in }
        
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: { completed in
            // maybe do something here
        })
        
        
    
    }
}

