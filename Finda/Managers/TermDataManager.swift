//
//  TermDataManager.swift
//  Finda
//
//  Created by Peter Lloyd on 26/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData



class TermDataManager {
    
    enum TermData: Int {
        case JobTypes = 1
        case Measurements = 2
        case HairType = 3
        case EyeColour = 4
        case HairLength = 5
        case HairColour = 6
        case Ethnicity = 7
        case EyebrowShape = 8
        case MemberTypes = 9
    }
    
    func load(term: TermData, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .termData(term: term)) { (response, result) in
            if(response){
                self.saveUserData(data: result, term: term)
                CoreDataManager.printEntity(entity: "Terms")
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
    
    private func saveUserData(data: JSON, term: TermData){
        let entity = "Terms"
        
        CoreDataManager.deleteAllData(entity: entity)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        
        let userData = data["userdata"]
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(userData.array, forKeyPath: "\(term.rawValue)")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

