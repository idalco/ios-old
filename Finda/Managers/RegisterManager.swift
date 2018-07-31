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
    
    
    static func model(mail: String, pass: String, firstname: String, lastname: String, gender: String, country: String, instagram_username: String, referral_code: String, dob: TimeInterval, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        
        FindaAPISession(target: .registerModel(mail: mail, pass: pass, firstname: firstname, lastname: lastname, gender: gender, country: country, instagram_username: instagram_username, referral_code: referral_code, dob: dob)) { (response, result) in
            if(response){
                _ = ModelManager(data: result)
                CoreDataManager.printEntity(entity: "User")
                let defaults = UserDefaults.standard
                defaults.set(result["userdata"]["token"].string, forKey: "access_token_auth")
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
    
}


