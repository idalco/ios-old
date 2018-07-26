//
//  TermData+CoreDataProperties.swift
//  
//
//  Created by Peter Lloyd on 26/07/2018.
//
//

import Foundation
import CoreData


extension Terms {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Terms> {
        return NSFetchRequest<Terms>(entityName: "Terms")
    }

    @NSManaged public var termData: NSObject?

}
