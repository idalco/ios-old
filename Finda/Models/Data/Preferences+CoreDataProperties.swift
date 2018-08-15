//
//  Preferences+CoreDataProperties.swift
//  
//
//  Created by Peter Lloyd on 31/07/2018.
//
//

import Foundation
import CoreData


extension Preferences {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Preferences> {
        return NSFetchRequest<Preferences>(entityName: "Preferences")
    }

    @NSManaged public var friendRegisters: Bool
    @NSManaged public var jobOffered: Bool
    @NSManaged public var jobCancelled: Bool
    @NSManaged public var jobChanged: Bool
    @NSManaged public var paymentMade: Bool
    @NSManaged public var notifications: Bool

}
