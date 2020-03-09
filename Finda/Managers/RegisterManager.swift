//
//  RegisterManager.swift
//  Finda
//
//  Created by Peter Lloyd on 31/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class RegisterManager {
    
    var window: UIWindow?
    
    static func model(mail: String, pass: String, firstname: String, lastname: String, gender: String, country: String, instagram_username: String, telephone: String, referral_code: String, dob: TimeInterval, location:String, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        
        FindaAPISession(target: .registerModel(mail: mail, pass: pass, firstname: firstname, lastname: lastname, gender: gender, country: country, instagram_username: instagram_username, telephone: telephone, referral_code: referral_code, dob: dob, location: location)) { (response, result) in
            if(response){
                _ = ModelManager(data: result)
                CoreDataManager.printEntity(entity: "User")
                let defaults = UserDefaults.standard
                defaults.set(result["userdata"]["token"].string, forKey: "access_token_auth")

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                var contentViewController  = storyboard.instantiateViewController(withIdentifier: "MainTabBar")
                let modelManager = ModelManager()
                if modelManager.status() == UserStatus.unverified || modelManager.status() == UserStatus.wewant || modelManager.status() == UserStatus.notsure {
                    contentViewController = storyboard.instantiateViewController(withIdentifier: "Settings")
                }
                
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {                    
                    appDelegate.setUpApplication()
                }

                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
    static func client(mail: String, pass: String, firstname: String, lastname: String, telephone: String, occupation: String, company_name: String, company_website: String, country: String, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        
        FindaAPISession(target: .registerClient(mail: mail, pass: pass, firstname: firstname, lastname: lastname, telephone: telephone, occupation: occupation, company_name: company_name, company_website: company_website, country: country)) { (response, result) in
            if(response){
                let defaults = UserDefaults.standard
                defaults.set(result["userdata"]["token"].string, forKey: "access_token_auth")
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
    
}


