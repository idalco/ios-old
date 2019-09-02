//
//  Profile+CoreDataProperties.swift
//  
//
//  Created by Peter Lloyd on 29/07/2018.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var height: Int32
    @NSManaged public var bust: Int32
    @NSManaged public var waist: Int32
    @NSManaged public var hips: Int32
    @NSManaged public var shoeSize: Int32
    @NSManaged public var dressSize: Int32
    @NSManaged public var suitSize: Int32
    @NSManaged public var hairColour: Int32
    @NSManaged public var hairType: Int32
    @NSManaged public var hairLength: Int32
    @NSManaged public var willingColour: Bool
    @NSManaged public var willingCut: Bool
    @NSManaged public var eyeColour: Int32
    @NSManaged public var ringSize: String
    @NSManaged public var dailyrate: Int32
    @NSManaged public var hourlyrate: Int32
    @NSManaged public var location: Int32
}
