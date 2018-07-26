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
import UIKit

class LoginManager {
    
    enum LoginStatus: Int {
        case Unverified = 0
        case verified = 1
        case Banned = 2
        case Special = 99
    }
    
    func login(email: String, password: String, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .login(email: email, password: password)) { (response, result) in
            if(response && result["status"] == 1){
                self.saveUserData(data: result)
                CoreDataManager.printEntity(entity: "User")
                completion(response, result)
            }
            completion(false, result)
        }
    }
    
    
    private func saveUserData(data: JSON){
        let entity = "User"
        
        CoreDataManager.deleteAllData(entity: entity)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        
        let userData = data["userdata"]

        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(userData["firstname"].string, forKeyPath: "firstName")
        user.setValue(userData["lastname"].string, forKeyPath: "lastName")
        user.setValue(userData["mail"].string, forKeyPath: "email")
        user.setValue(userData["avatar"].string, forKeyPath: "avatar")
        user.setValue(userData["usertype"].intValue, forKeyPath: "userType")
        user.setValue(userData["instagram_username"].string, forKeyPath: "instagramUsername")
        user.setValue(userData["instagram_followers"].intValue, forKeyPath: "instagramFollowers")
        user.setValue(userData["occupation"].string, forKeyPath: "occupation")
        user.setValue(userData["company_name"].string, forKeyPath: "companyName")
        user.setValue(userData["company_website"].string, forKeyPath: "companyWebsite")
        user.setValue(userData["dob"].intValue, forKeyPath: "dob")
        user.setValue(userData["country"].string, forKeyPath: "country")
        user.setValue(userData["nationality"].string, forKeyPath: "nationality")
        user.setValue(userData["residence_country"].string, forKeyPath: "residenceCountry")
        user.setValue(userData["bank_sortcode"].string, forKeyPath: "bankSortcode")
        user.setValue(userData["bank_accountnumber"].string, forKeyPath: "bankAccountNumber")
        user.setValue(userData["bank_accountname"].string, forKeyPath: "bankAccountName")
        user.setValue(userData["vat_number"].string, forKeyPath: "vatNumber")
        user.setValue(userData["referrer_code"].string, forKeyPath: "referrerCode")
        user.setValue(userData["lead_image"].string, forKeyPath: "leadImage")
        user.setValue(userData["ethnicity"].intValue, forKeyPath: "ethnicity")
        user.setValue(userData["available"].intValue, forKeyPath: "available")
        user.setValue(userData["status"].intValue, forKeyPath: "status")
    
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

