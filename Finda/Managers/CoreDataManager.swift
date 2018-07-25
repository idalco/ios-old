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
        
        print(users)
    }
    
}
