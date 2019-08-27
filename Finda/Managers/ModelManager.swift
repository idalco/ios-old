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

    
    enum Entity: String {
        case User = "User"
        case Profile = "Profile"
        case Preferences = "Preferences"
    }
    
    enum User: String {
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "email"
        case avatar = "avatar"
        case filename = "filename"
        case userType = "userType"
        case gender = "gender"
        case instagramUsername = "instagramUsername"
        case instagramFollowers = "instagramFollowers"
        case occupation = "occupation"
        case companyName = "companyName"
        case telephone = "telephone"
        case companyWebsite = "companyWebsite"
        case dob = "dob"
        case country = "country"
        case nationality = "nationality"
        case residenceCountry = "residenceCountry"
        case bankSortcode = "bankSortcode"
        case bankAccountNumber = "bankAccountNumber"
        case bankAccountName = "bankAccountName"
        case vatNumber = "vatNumber"
        case referrerCode = "referrerCode"
        case leadImage = "leadImage"
        case ethnicity = "ethnicity"
        case available = "available"
        case status = "status"
        case kycBy = "kycBy"
        case kycOn = "kycOn"
    }
    
    enum Profile: String {
        case height = "height"
        case bust = "bust"
        case waist = "waist"
        case hips = "hips"
        case shoeSize = "shoeSize"
        case dressSize = "dressSize"
        case suitSize = "suitSize"
        case hairColour = "hairColour"
        case hairType = "hairType"
        case hairLength = "hairLength"
        case willingColour = "willingColour"
        case willingCut = "willingCut"
        case drivingLicense = "drivingLicense"
        case tattoo = "tattoo"
        case eyeColour = "eyeColour"
        case hourlyrate = "hourlyrate"
        case dailyrate = "dailyrate"
        case location = "location"
    }
    
    enum Preferences: String {
        case friendRegisters = "friendRegisters"
        case jobOffered = "jobOffered"
        case jobCancelled = "jobCancelled"
        case jobChanged = "jobChanged"
        case paymentMade = "paymentMade"
        case notifications = "notifications"
    }
    
    
    init(data: JSON) {
        self.saveUserData(data: data)
    }
    
    init() {
        
    }
    
    /*
        User Entity
     */
    
    func firstName() -> String {
        return CoreDataManager.getString(dataName: User.firstName.rawValue, entity: Entity.User.rawValue)
    }
    
    func lastName() -> String {
        return CoreDataManager.getString(dataName: User.lastName.rawValue, entity: Entity.User.rawValue)
    }
    
    func email() -> String {
        return CoreDataManager.getString(dataName: User.email.rawValue, entity: Entity.User.rawValue)
    }
    
    func telephone() -> String {
        return CoreDataManager.getString(dataName: User.telephone.rawValue, entity: Entity.User.rawValue)
    }
    
    func avatar() -> String {
        return CoreDataManager.getString(dataName: User.avatar.rawValue, entity: Entity.User.rawValue)
    }
    
    func filename() -> String {
        return CoreDataManager.getString(dataName: User.filename.rawValue, entity: Entity.User.rawValue)
    }
    
    func userType() -> UserType? {
        return UserType.init(rawValue: CoreDataManager.getInt(dataName: User.userType.rawValue, entity: Entity.User.rawValue)) ?? nil
        
    }
    
    func gender() -> String {
        return CoreDataManager.getString(dataName: User.gender.rawValue, entity: Entity.User.rawValue)
    }
    
    func instagramUserName() -> String {
        return CoreDataManager.getString(dataName: User.instagramUsername.rawValue, entity: Entity.User.rawValue)
    }
    
    func instagramFollowers() -> Int {
        return CoreDataManager.getInt(dataName: User.instagramFollowers.rawValue, entity: Entity.User.rawValue)
    }
    
    func occupation() -> String {
        return CoreDataManager.getString(dataName: User.occupation.rawValue, entity: Entity.User.rawValue)
    }
    
    func companyName() -> String {
        return CoreDataManager.getString(dataName: User.companyName.rawValue, entity: Entity.User.rawValue)
    }
    
    func companyWebsite() -> String {
        return CoreDataManager.getString(dataName: User.companyWebsite.rawValue, entity: Entity.User.rawValue)
    }
    
    func dateOfBirth() -> Int {
        return CoreDataManager.getInt(dataName: User.dob.rawValue, entity: Entity.User.rawValue)
    }
    
    func country() -> String {
        return CoreDataManager.getString(dataName: User.country.rawValue, entity: Entity.User.rawValue)
    }
    
    func nationality() -> String {
        return CoreDataManager.getString(dataName: User.nationality.rawValue, entity: Entity.User.rawValue)
    }
    
    func residenceCountry() -> String {
        return CoreDataManager.getString(dataName: User.residenceCountry.rawValue, entity: Entity.User.rawValue)
    }
    
    func bankSortcode() -> String {
        return CoreDataManager.getString(dataName: User.bankSortcode.rawValue, entity: Entity.User.rawValue)
    }
    
    func bankAccountNumber() -> String {
        return CoreDataManager.getString(dataName: User.bankAccountNumber.rawValue, entity: Entity.User.rawValue)
    }
    
    func bankAccountName() -> String {
        return CoreDataManager.getString(dataName: User.bankAccountName.rawValue, entity: Entity.User.rawValue)
    }
    
    func vatNumber() -> String {
        return CoreDataManager.getString(dataName: User.vatNumber.rawValue, entity: Entity.User.rawValue)
    }
    
    func referrerCode() -> String {
        return CoreDataManager.getString(dataName: User.referrerCode.rawValue, entity: Entity.User.rawValue)
    }
    
    func leadImage() -> String {
        return CoreDataManager.getString(dataName: User.leadImage.rawValue, entity: Entity.User.rawValue)
    }
    
    func ethnicity() -> Int {
        return CoreDataManager.getInt(dataName: User.ethnicity.rawValue, entity: Entity.User.rawValue)
    }
    
    func available() -> Bool {
        return CoreDataManager.getBool(dataName: User.available.rawValue, entity: Entity.User.rawValue)
    }
    
    func status() -> UserStatus? {
        return UserStatus(rawValue: CoreDataManager.getInt(dataName: User.status.rawValue, entity: Entity.User.rawValue)) ?? nil
        
    }
    
    func kycOn() -> Int {
        return CoreDataManager.getInt(dataName: User.kycOn.rawValue, entity: Entity.User.rawValue)
    }
    
    func kycBy() -> Int {
        return CoreDataManager.getInt(dataName: User.kycBy.rawValue, entity: Entity.User.rawValue)
    }

    /*
        Profile Entity
    */
    func height() -> Int {
        return CoreDataManager.getInt(dataName: Profile.height.rawValue, entity: Entity.Profile.rawValue)
    }
    func bust() -> Int {
        return CoreDataManager.getInt(dataName: Profile.bust.rawValue, entity: Entity.Profile.rawValue)
    }
    func waist() -> Int {
        return CoreDataManager.getInt(dataName: Profile.waist.rawValue, entity: Entity.Profile.rawValue)
    }
    func hips() -> Int {
        return CoreDataManager.getInt(dataName: Profile.hips.rawValue, entity: Entity.Profile.rawValue)
    }
    func shoeSize() -> Int {
        return CoreDataManager.getInt(dataName: Profile.shoeSize.rawValue, entity: Entity.Profile.rawValue)
    }
    func dressSize() -> Int {
        return CoreDataManager.getInt(dataName: Profile.dressSize.rawValue, entity: Entity.Profile.rawValue)
    }
    func suitSize() -> Int {
        return CoreDataManager.getInt(dataName: Profile.suitSize.rawValue, entity: Entity.Profile.rawValue)
    }
    func hairColour() -> Int {
        return CoreDataManager.getInt(dataName: Profile.hairColour.rawValue, entity: Entity.Profile.rawValue)
    }
    func hairType() -> Int {
        return CoreDataManager.getInt(dataName: Profile.hairType.rawValue, entity: Entity.Profile.rawValue)
    }
    func hairLength() -> Int {
        return CoreDataManager.getInt(dataName: Profile.hairLength.rawValue, entity: Entity.Profile.rawValue)
    }
    func willingColour() -> Bool {
        return CoreDataManager.getBool(dataName: Profile.willingColour.rawValue, entity: Entity.Profile.rawValue)
    }
    func willingCut() -> Bool {
        return CoreDataManager.getBool(dataName: Profile.willingCut.rawValue, entity: Entity.Profile.rawValue)
    }
    func drivingLicense() -> Bool {
        return CoreDataManager.getBool(dataName: Profile.drivingLicense.rawValue, entity: Entity.Profile.rawValue)
    }
    func tattoo() -> Bool {
        return CoreDataManager.getBool(dataName: Profile.tattoo.rawValue, entity: Entity.Profile.rawValue)
    }
    func eyeColour() -> Int {
        return CoreDataManager.getInt(dataName: Profile.eyeColour.rawValue, entity: Entity.Profile.rawValue)
    }
 
    func hourlyrate() -> Int {
        return CoreDataManager.getInt(dataName: Profile.hourlyrate.rawValue, entity: Entity.Profile.rawValue)
    }

    func dailyrate() -> Int {
        return CoreDataManager.getInt(dataName: Profile.dailyrate.rawValue, entity: Entity.Profile.rawValue)
    }

    func location() -> Int {
        return CoreDataManager.getInt(dataName: Profile.location.rawValue, entity: Entity.Profile.rawValue)
    }
    

 
 /*
    Preferences Entity
 */
    
    func friendRegisters() -> Bool {
        return CoreDataManager.getBool(dataName: Preferences.friendRegisters.rawValue, entity: Entity.Preferences.rawValue)
    }

    func jobOffered() -> Bool {
        return CoreDataManager.getBool(dataName: Preferences.jobOffered.rawValue, entity: Entity.Preferences.rawValue)
    }

    func jobCancelled() -> Bool {
        return CoreDataManager.getBool(dataName: Preferences.jobCancelled.rawValue, entity: Entity.Preferences.rawValue)
    }
    
    func jobChanged() -> Bool {
        return CoreDataManager.getBool(dataName: Preferences.jobChanged.rawValue, entity: Entity.Preferences.rawValue)
    }

    func paymentMade() -> Bool {
        return CoreDataManager.getBool(dataName: Preferences.paymentMade.rawValue, entity: Entity.Preferences.rawValue)
    }

    func notifications() -> Bool {
        return CoreDataManager.getBool(dataName: Preferences.notifications.rawValue, entity: Entity.Preferences.rawValue)
    }
    
    
    
    
    private func saveUserData(data: JSON){
        let entity = Entity.User.rawValue
        
        CoreDataManager.deleteAllData(entity: entity)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        
        let userData = data["userdata"]
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(userData["firstname"].string, forKeyPath: User.firstName.rawValue)
        user.setValue(userData["lastname"].string, forKeyPath: User.lastName.rawValue)
        user.setValue(userData["mail"].string, forKeyPath: "email")
        user.setValue(userData["telephone"].string, forKeyPath: "telephone")
        user.setValue(userData["avatar"].string, forKeyPath: User.avatar.rawValue)
        user.setValue(userData["filename"].string, forKeyPath: User.filename.rawValue)
        user.setValue(userData["usertype"].intValue, forKeyPath: User.userType.rawValue)
        user.setValue(userData["instagram_username"].string, forKeyPath: User.instagramUsername.rawValue)
        user.setValue(userData["instagram_followers"].intValue, forKeyPath: User.instagramFollowers.rawValue)
        user.setValue(userData["occupation"].string, forKeyPath: User.occupation.rawValue)
        user.setValue(userData["company_name"].string, forKeyPath: User.companyName.rawValue)
        user.setValue(userData["company_website"].string, forKeyPath: User.companyWebsite.rawValue)
        user.setValue(userData["dob"].intValue, forKeyPath: User.dob.rawValue)
        user.setValue(userData["country"].string, forKeyPath: User.country.rawValue)
        user.setValue(userData["nationality"].string, forKeyPath: User.nationality.rawValue)
        user.setValue(userData["residence_country"].string, forKeyPath: User.residenceCountry.rawValue)
        user.setValue(userData["bank_sortcode"].string, forKeyPath: User.bankSortcode.rawValue)
        user.setValue(userData["bank_accountnumber"].string, forKeyPath: User.bankAccountNumber.rawValue)
        user.setValue(userData["bank_accountname"].string, forKeyPath: User.bankAccountName.rawValue)
        user.setValue(userData["vat_number"].string, forKeyPath: User.vatNumber.rawValue)
        user.setValue(userData["referrer_code"].string, forKeyPath: User.referrerCode.rawValue)
        user.setValue(userData["lead_image"].string, forKeyPath: User.leadImage.rawValue)
        user.setValue(userData["ethnicity"].intValue, forKeyPath: User.ethnicity.rawValue)
        user.setValue(userData["available"].intValue, forKeyPath: User.available.rawValue)
        user.setValue(userData["status"].intValue, forKeyPath: User.status.rawValue)
        user.setValue(userData["gender"].string, forKeyPath: User.gender.rawValue)
        user.setValue(userData["kyc_by"].intValue, forKeyPath: User.kycBy.rawValue)
        user.setValue(userData["kyc_on"].intValue, forKeyPath: User.kycOn.rawValue)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.saveProfile(data: data)
    }
    
    private func saveProfile(data: JSON){
        let entity = Entity.Profile.rawValue
        CoreDataManager.deleteAllData(entity: entity)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        
        let profileData = data["userdata"]["profile"]
        
        let profile = NSManagedObject(entity: userEntity, insertInto: managedContext)
        profile.setValue(profileData["height"].intValue, forKeyPath: Profile.height.rawValue)
        profile.setValue(profileData["bust"].intValue, forKeyPath: Profile.bust.rawValue)
        profile.setValue(profileData["waist"].intValue, forKeyPath: Profile.waist.rawValue)
        profile.setValue(profileData["hips"].intValue, forKeyPath: Profile.hips.rawValue)
        profile.setValue(profileData["shoesize"].intValue, forKeyPath: Profile.shoeSize.rawValue)
        profile.setValue(profileData["dresssize"].intValue, forKeyPath: Profile.dressSize.rawValue)
        profile.setValue(profileData["suitsize"].intValue, forKeyPath: Profile.suitSize.rawValue)
        profile.setValue(profileData["haircolour_tid"].intValue, forKeyPath: Profile.hairColour.rawValue)
        profile.setValue(profileData["hairtype_tid"].intValue, forKeyPath: Profile.hairType.rawValue)
        profile.setValue(profileData["hairlength_tid"].intValue, forKeyPath: Profile.hairLength.rawValue)
        profile.setValue(profileData["willingtodye"].boolValue, forKeyPath: Profile.willingColour.rawValue)
        profile.setValue(profileData["willingtocut"].boolValue, forKeyPath: Profile.willingCut.rawValue)
        profile.setValue(profileData["drivinglicense"].boolValue, forKeyPath: Profile.drivingLicense.rawValue)
        profile.setValue(profileData["tattoo"].boolValue, forKeyPath: Profile.tattoo.rawValue)
        profile.setValue(profileData["eyecolour_tid"].intValue, forKeyPath: Profile.eyeColour.rawValue)
        profile.setValue(profileData["hourlyrate"].intValue, forKeyPath: Profile.hourlyrate.rawValue)
        profile.setValue(profileData["dailyrate"].intValue, forKeyPath: Profile.dailyrate.rawValue)
        profile.setValue(profileData["location"].intValue, forKeyPath: Profile.location.rawValue)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.savePreferences(data: data)
    }
    
    private func savePreferences(data: JSON){
        let entity = Entity.Preferences.rawValue
        CoreDataManager.deleteAllData(entity: entity)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        
        let profileData = data["userdata"]["prefs"]
        
        let profile = NSManagedObject(entity: userEntity, insertInto: managedContext)
        profile.setValue(profileData["friend_registers"].boolValue, forKeyPath: Preferences.friendRegisters.rawValue)
        profile.setValue(profileData["job_offered"].boolValue, forKeyPath: Preferences.jobOffered.rawValue)
        profile.setValue(profileData["job_cancelled"].boolValue, forKeyPath: Preferences.jobCancelled.rawValue)
        profile.setValue(profileData["job_changed"].boolValue, forKeyPath: Preferences.jobChanged.rawValue)
        profile.setValue(profileData["payment_made"].boolValue, forKeyPath: Preferences.paymentMade.rawValue)
        profile.setValue(profileData["notifications"].boolValue, forKeyPath: Preferences.notifications.rawValue)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func LoadUserData() {
        let entity = Entity.User.rawValue
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        
        
    }
    
}
