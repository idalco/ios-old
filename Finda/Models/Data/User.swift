//
//  User.swift
//  Finda
//
//  Created by Peter Lloyd on 25/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import Marshal

final class User: NSObject, Unmarshaling {
    var firstName: String
    var lastName: String
    var email: String
    var avatar: String
    var userType: Int
    var instagramUsername: String?
    var instagramFollowers: Int
    var occupation: String?
    var companyName: String?
    var companyWebsite: String?
    var dob: Int
    var country: String?
    var nationality: String?
    var residenceCountry: String?
    var bankSortcode: String?
    var bankAccountnumber: String?
    var bankAccountname: String?
    var vatNumber: String?
    var referrerCode: String?
    var leadImage: String?
    var ethnicity: Int
    var available: Int
    
    init(firstName: String, lastName: String, email: String, avatar: String, userType: Int, instagramUsername: String, instagramFollowers: Int, occupation: String, companyName: String, companyWebsite: String, dob: Int, country: String, nationality: String, residenceCountry: String, bankSortcode: String, bankAccountnumber: String, bankAccountname: String, vatNumber: String, referrerCode: String, leadImage: String, ethnicity: Int, available: Int) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.avatar = avatar
        self.userType = userType
        self.instagramUsername = instagramUsername
        self.instagramFollowers = instagramFollowers
        self.occupation = occupation
        self.companyName = companyName
        self.companyWebsite = companyWebsite
        self.dob = dob
        self.country = country
        self.nationality = nationality
        self.residenceCountry = residenceCountry
        self.bankSortcode = bankSortcode
        self.bankAccountnumber = bankAccountnumber
        self.bankAccountname = bankAccountname
        self.vatNumber = vatNumber
        self.referrerCode = referrerCode
        self.leadImage = leadImage
        self.ethnicity = ethnicity
        self.available = available
    }
    
    init(object: MarshaledObject) throws {
        firstName = try object.value(for: "firstname")
        lastName = try object.value(for: "lastname")
        email = try object.value(for: "mail")
        avatar = try object.value(for: "avatar")
        userType = try object.value(for: "usertype")
        instagramUsername = try object.value(for: "instagram_username")
        instagramFollowers = try object.value(for: "instagram_followers")
        occupation = try object.value(for: "occupation")
        companyName = try object.value(for: "company_name")
        companyWebsite = try object.value(for: "company_website")
        dob = try object.value(for: "dob")
        country = try object.value(for: "country")
        nationality = try object.value(for: "nationality")
        residenceCountry = try object.value(for: "residence_country")
        bankSortcode = try object.value(for: "bank_sortcode")
        bankAccountnumber = try object.value(for: "bank_accountnumber")
        bankAccountname = try object.value(for: "bank_accountname")
        vatNumber = try object.value(for: "vat_number")
        referrerCode = try object.value(for: "referrer_code")
        leadImage = try object.value(for: "lead_image")
        ethnicity = try object.value(for: "ethnicity")
        available = try object.value(for: "available")
    }
    
}
