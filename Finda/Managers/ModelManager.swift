//
//  ModelManager.swift
//  Finda
//
//  Created by Peter Lloyd on 31/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class ModelManager {
    
    init(data: JSON){
        self.saveUserData(data: data)
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
        user.setValue("https://www.finda.co/avatar/thumb\(userData["avatar"].string ?? "")", forKeyPath: "avatar")
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
        self.saveProfile(data: data)
    }
    
    private func saveProfile(data: JSON){
        let entity = "Profile"
        CoreDataManager.deleteAllData(entity: entity)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        
        let profileData = data["userdata"]["profile"]
        
        let profile = NSManagedObject(entity: userEntity, insertInto: managedContext)
        profile.setValue(profileData["height"].intValue, forKeyPath: "height")
        profile.setValue(profileData["bust"].intValue, forKeyPath: "bust")
        profile.setValue(profileData["waist"].intValue, forKeyPath: "waist")
        profile.setValue(profileData["hips"].intValue, forKeyPath: "hips")
        profile.setValue(profileData["shoesize"].intValue, forKeyPath: "shoeSize")
        profile.setValue(profileData["dresssize"].intValue, forKeyPath: "dressSize")
        profile.setValue(profileData["haircolour_tid"].intValue, forKeyPath: "hairColour")
        profile.setValue(profileData["hairtype_tid"].intValue, forKeyPath: "hairType")
        profile.setValue(profileData["hairlength_tid"].intValue, forKeyPath: "hairLength")
        profile.setValue(profileData["willingcolour_tid"].intValue, forKeyPath: "willingColour")
        profile.setValue(profileData["willingcut_tid"].intValue, forKeyPath: "willingCut")
        profile.setValue(profileData["eyecolour_tid"].intValue, forKeyPath: "eyeColour")
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
