//
//  CoreDataManager.swift
//  Finda
//
//  Created by Peter Lloyd on 25/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static func deleteAllData(entity: String) {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            _ = try managedContext.execute(request)
        } catch(_){}
        
    }
    
    static func printEntity(entity: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let users = try! managedContext.fetch(userFetch)
        print("CoreData: ")
        print(users)
    }
    
    static func getString(dataName: String, entity: String) -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(request)
            let res = (results as! [NSManagedObject]).last
            
            if let data = res?.value(forKey: dataName) as? String {
                return data
            }
        } catch {}
        return ""
    }
    
    static func getInt(dataName: String, entity: String) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(request)
            let res = (results as! [NSManagedObject]).last
            
            if let data = res?.value(forKey: dataName) as? Int {
                return data
            }
        } catch {}
        return -1
    }

    
    
}
