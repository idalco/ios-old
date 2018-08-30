//
//  User+CoreDataProperties.swift
//  
//
//  Created by Peter Lloyd on 25/07/2018.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var avatar: String?
    @NSManaged public var filename: String?
    @NSManaged public var userType: Int32
    @NSManaged public var instagramUsername: String?
    @NSManaged public var instagramFollowers: Int32
    @NSManaged public var occupation: String?
    @NSManaged public var companyName: String?
    @NSManaged public var companyWebsite: String?
    @NSManaged public var dob: Int64
    @NSManaged public var country: String?
    @NSManaged public var nationality: String?
    @NSManaged public var residenceCountry: String?
    @NSManaged public var bankSortcode: String?
    @NSManaged public var bankAccountNumber: String?
    @NSManaged public var bankAccountName: String?
    @NSManaged public var vatNumber: String?
    @NSManaged public var referrerCode: String?
    @NSManaged public var leadImage: String?
    @NSManaged public var ethnicity: Int32
    @NSManaged public var available: Int32
    @NSManaged public var status: Int32
    @NSManaged public var gender: String?

}
