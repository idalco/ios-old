//
//  FindaAPI.swift
//  Finda
//

import Foundation
import Moya
import SwiftyJSON


let FindaAPIManager = MoyaProvider<FindaAPI>( plugins: [
    NetworkLoggerPlugin(),
    VerbosePlugin(verbose: true),
    FindaHMACPlugin(),
    FindaTokenPlugin(tokenClosure: accessToken())
    ])

//let domainURL: String = "http://dev.finda.co"
//let domainURL: String = "http://dev.finda"
let domainURL: String = "https://www.idal.co"

enum FindaAPI {
    // POST
    case login(email: String, password: String)
    case registerModel(mail: String, pass: String, firstname: String, lastname: String, gender: String, country: String, instagram_username: String, telephone: String, referral_code: String?, dob: TimeInterval, location: String)
    case registerClient(mail: String, pass: String, firstname: String, lastname: String, telephone: String, occupation: String, company_name: String, company_website: String, country: String)
    case termData(term: TermDataManager.TermData)
    case logout
    case getJobs(jobType: JobsManager.JobTypes)
    case getNotifications(notificationType: NotificationManager.NotificationTypes)
    case getChatMessages(sender: Int)
    case sendChatMessage(recipient: Int, message: String, subject: String, type: Int)
    case countNotifications(notificationType: NotificationManager.NotificationTypes)
    case deleteNotifications(id: Int)
    case flagNotifications(id: Int)
    case updateProfile(firstName: String, lastName: String, email: String, telephone: String, nationality: String, residence_country: String, ethnicityId: Int, instagramUsername: String, referralCode: String, vatNumber: String, locationTid: Int)
    
    case updateMeasurements(height: Int, bust: Int, waist: Int, hips: Int, shoeSize: Float, collarSize: Float, dressSize: Float, suitSize: Float, hairColour: Int, hairLength: Int, hairType: Int, eyeColour: Int, ringSize: String, willingToColour: String, willingToCut: String, drivingLicense: String, tattoo: String, hourlyrate: Int, dailyrate: Int, cupsize: Int, skintone: Int)
    
    case updatePreferences(friend_registers: String, job_offered: String, job_cancelled: String, job_changed: String, payment_made: String, notifications: String)
    case updatePassword(oldPassword: String, newPassword: String, repeatNewPassword: String)
    case uploadPortfolioImage(image: UIImage)
    case uploadPolaroidImage(image: UIImage)
    case uploadVerificationImage(image: UIImage)
    case uploadChatImage(image: UIImage)
    case getImages(type: ImageType)
    case deleteImage(id: Int)
    case selectLeadImage(id: Int)
    case saveImageOrder(imageOrder: Array<Int>, imageType: String)
    case inviteFriend(name: String, email: String)
    case supportRequest(request: String, reason: Int)
    case updateBankDetails(name: String, sortcode: String, accountNumber: String, ibanNumber: String)
    case getModelInvoices
    case acceptJob(jobId: Int)
    case rejectJob(jobId: Int)
    case cancelJob(jobId: Int)
    case completeJob(jobId: Int)
    case rejectOption(jobId: Int)
    case negotiateRate(jobId: Int, newRate: Int, reasons: Array<Int>)
    case updateDeviceToken(deviceToken: String)
    case updateAvailability(availability: Int)
    case getCalendar
    case getCalendarEntriesForDate(date: Double)
    case newCalendarEntry(title: String, allday: Bool, starttime: Double, endtime: Double, location: String, state: String, isediting: Bool)
    case deleteCalendarEntry(entry: String)
    case updateCalendarEntry(scheduleId: String, title: String, allday: Bool, starttime: Double, endtime: Double, location: String, state: String)
    case setLastMinute(availability: [String:Int])

    // GET
    case userDetails
    case getLastMinute
    case getReferrals
    case getCommunityPosts
    
}

extension FindaAPI: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL { return URL(string: "\(domainURL)/api/1.0")! }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .termData:
            return "/getTerms"
        case .logout:
            return "/logout"
        case .registerModel:
            return "/register"
        case .registerClient:
            return "/register"
        case .getJobs:
            return "/getJobs"
        case .getNotifications:
            return "/getNotifications"
        case .getChatMessages:
            return "/getChatMessages"
        case .sendChatMessage:
            return "/sendChatMessage"
        case .countNotifications:
            return "/getNotifications"
        case .deleteNotifications:
            return "/deleteNotification"
        case .updateProfile:
            return "/updateProfile"
        case .updateMeasurements:
            return "/updateProfile"
        case .updatePreferences:
            return "/updateProfile"
        case .updatePassword:
            return "/updateProfile"
        case .uploadPortfolioImage:
            return "/uploadPortfolio"
        case .uploadPolaroidImage:
            return "/uploadPolaroid"
        case .uploadVerificationImage:
            return "/uploadKYC"
        case .uploadChatImage:
            return "/uploadChatImage"
        case .getImages:
            return "/getImages"
        case .deleteImage:
            return "/removeImage"
        case .selectLeadImage:
            return "/selectLeadImage"
        case .saveImageOrder:
            return "/saveImageOrder"
        case .inviteFriend:
            return "/inviteFriend"
        case .supportRequest:
            return "/support"
        case .updateBankDetails:
            return "/updateProfile"
        case .getModelInvoices:
            return "/getModelInvoices"
        case .rejectOption:
            return "/rejectOption"
        case .acceptJob:
            return "/acceptBooking"
        case .rejectJob:
            return "/rejectBooking"
        case .cancelJob:
            return "/cancelBooking"
        case .completeJob:
            return "/completeBooking"
        case .userDetails:
            return "/userLoad"
        case .updateDeviceToken:
            return "/updateDeviceToken"
        case .updateAvailability:
            return "/updateAvailability"
        case .negotiateRate:
            return "/negotiateBooking"
        case .getCalendar:
            return "/getCalendar"
        case .getCalendarEntriesForDate:
            return "/getCalendarEvents"
        case .newCalendarEntry:
            return "/addCalendarEvent"
        case .deleteCalendarEntry:
            return "/deleteCalendarEvent"
        case .updateCalendarEntry:
            return "/updateCalendarEvent"
        case .getLastMinute:
            return "/getLastMinute"
        case .setLastMinute:
            return "/setLastMinute"
        case .flagNotifications:
            return "/flagNotification"
        case .getReferrals:
            return "/getReferrals"
        case .getCommunityPosts:
            return "/getCommunityPosts"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        
        // methods requiring POST
        case .login, .termData, .logout, .registerModel, .registerClient, .getNotifications, .getChatMessages, .sendChatMessage, .countNotifications, .deleteNotifications, .flagNotifications, .updateProfile, .updateMeasurements, .updatePreferences, .updatePassword, .uploadPortfolioImage, .uploadPolaroidImage, .uploadVerificationImage, .uploadChatImage, .getImages, .deleteImage, .selectLeadImage, .saveImageOrder, .inviteFriend, .supportRequest, .updateBankDetails, .rejectOption, .acceptJob, .rejectJob, .cancelJob, .completeJob, .updateDeviceToken, .updateAvailability, .negotiateRate, .newCalendarEntry, .deleteCalendarEntry, .updateCalendarEntry, .setLastMinute:
            return .post
            
        // methods requiring GET
        case .userDetails, .getJobs, .getModelInvoices, .getCalendar, .getCalendarEntriesForDate, .getLastMinute, .getReferrals, .getCommunityPosts:
            return .get
        }
    }
    
    var task: Task {
        var p = [String: Any]()
        switch self {
        
        case .login(let email, let password):
            p["email"] = email
            p["password"] = password
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        case .termData(let vid):
            p["vid"] = vid.rawValue
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        case .registerModel(let mail, let pass, let firstname, let lastname, let gender, let country, let instagram_username, let telephone, let referral_code, let dob, let location):
            p["email"] = mail
            p["password"] = pass
            p["firstname"] = firstname
            p["lastname"] = lastname
            if gender.lowercased() == "non-binary" {
                p["gender"] = "other"
            } else if gender.lowercased() == "woman" {
                p["gender"] = "female"
            } else {
                p["gender"] = "man"
            }
            p["country"] = country
            p["userlocation"] = location
            p["usertype"] = "model"
            p["telephone"] = telephone
            p["agree_terms"] = 1
            p["instagram_username"] = instagram_username
            if (referral_code != nil && referral_code != "") {
                p["referral_code"] = referral_code
            }
            p["dob"] = Int(dob)
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .registerClient(let mail, let pass, let firstname, let lastname, let telephone, let occupation, let company_name, let company_website, let country):
            p["email"] = mail
            p["password"] = pass
            p["firstname"] = firstname
            p["lastname"] = lastname
            p["telephone"] = telephone
            p["occupation"] = occupation
            p["company_name"] = company_name
            p["company_website"] = company_website
            p["gender"] = "other".lowercased()
            p["country"] = country
            p["usertype"] = "brand"
            p["agree_terms"] = 1
            p["dob"] = 0
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)

            
        case .getJobs(let jobType):
            p["type"] = jobType.rawValue
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .getNotifications(let notificationType):
            p["type"] = notificationType.rawValue
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .getChatMessages(let sender):
            p["sender"] = sender
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .sendChatMessage(let recipient, let message, let subject, let type):
            p["recipient"] = recipient
            p["message"] = message
            p["subject"] = subject
            p["type"] = type
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)

        case .countNotifications(let notificationType):
            p["type"] = notificationType.rawValue
            p["count"] = true
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .deleteNotifications(let id):
            p["msgid"] = id
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .flagNotifications(let id):
            p["msgid"] = id
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)

        case .updateProfile(let firstName, let lastName, let email, let telephone, let nationality, let residence_country, let ethnicityId, let instagramUsername, let referralCode, let vatNumber, let locationTid):
            var parameters = [String: Any]()
            
            parameters["firstname"] = firstName
            parameters["lastname"] = lastName
            parameters["mail"] = email
            parameters["telephone"] = telephone
            parameters["ethnicity"] = ethnicityId
            parameters["instagram"] = instagramUsername
            if (referralCode != "") {
                parameters["referral_code"] = referralCode
            }
            if (vatNumber != "") {
                parameters["vat_number"] = vatNumber
            }
            parameters["nationality"] = nationality
            parameters["residence_country"] = residence_country
            parameters["location"] = locationTid

            p["parameters"] = parameters
         
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .updateMeasurements(let height, let bust, let waist, let hips, let shoeSize, let collarSize, let dressSize, let suitSize, let hairColour, let hairLength, let hairType, let eyeColour, let ringSize,  let willingToColour, let willingToCut, let drivingLicense, let tattoo, let hourlyrate, let dailyrate, let cupsize, let skintone):
            var parameters = [String: Any]()
            parameters["height"] = height
            parameters["bust"] = bust
            parameters["waist"] = waist
            parameters["hips"] = hips
            parameters["shoesize"] = shoeSize
            parameters["dresssize"] = dressSize
            parameters["suitsize"] = suitSize
            parameters["collarsize"] = collarSize
            parameters["haircolour"] = hairColour
            parameters["hairlength"] = hairLength
            parameters["hairtype"] = hairType
            parameters["eyecolour"] = eyeColour
            parameters["ringsize"] = ringSize
            parameters["willingtodye"] = willingToColour
            parameters["willingtocut"] = willingToCut
            parameters["drivinglicense"] = drivingLicense
            parameters["tattoo"] = tattoo
            parameters["hourlyrate"] = hourlyrate
            parameters["dailyrate"] = dailyrate
            parameters["cupsize"] = cupsize
            parameters["skintone"] = skintone

            p["parameters"] = parameters
            
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .updatePreferences(let friend_registers, let job_offered, let job_cancelled, let job_changed, let payment_made, let notifications):
            var parameters = [String: Any]()
            parameters["friend_registers"] = friend_registers
            parameters["job_offered"] = job_offered
            parameters["job_cancelled"] = job_cancelled
            parameters["job_changed"] = job_changed
            parameters["payment_made"] = payment_made
            parameters["notifications"] = notifications
            
            p["parameters"] = parameters
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
       
        case .updatePassword(let oldPassword, let newPassword, let repeatNewPassword):
            var parameters = [String: Any]()
            parameters["oldpassword"] = oldPassword
            parameters["newpassword"] = newPassword
            parameters["confirmpassword"] = repeatNewPassword
            p["parameters"] = parameters
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .uploadPolaroidImage(let image):
            guard let jpegRep = image.jpegData(compressionQuality: 1.0) else { return .uploadMultipart([]) }
            let jpegData = MultipartFormData(provider: .data(jpegRep), name: "polaroids", fileName: "image.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([jpegData])
            
        case .uploadPortfolioImage(let image):
            guard let jpegRep = image.jpegData(compressionQuality: 1.0) else { return .uploadMultipart([]) }
            let jpegData = MultipartFormData(provider: .data(jpegRep), name: "portfolio", fileName: "image.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([jpegData])
            
        case .uploadVerificationImage(let image):
            guard let jpegRep = image.jpegData(compressionQuality: 1.0) else { return .uploadMultipart([]) }
            let jpegData = MultipartFormData(provider: .data(jpegRep), name: "kyc", fileName: "image.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([jpegData])

            case .uploadChatImage(let image):
                guard let jpegRep = image.jpegData(compressionQuality: 1.0) else { return .uploadMultipart([]) }
                let jpegData = MultipartFormData(provider: .data(jpegRep), name: "chatAttachment", fileName: "image.jpeg", mimeType: "image/jpeg")
                return .uploadMultipart([jpegData])
            
        case.getImages(let type):
             p["imagetype"] = type.rawValue
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .deleteImage(let id):
            p["imageid"] = id
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .selectLeadImage(let id):
            p["imageid"] = id
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .saveImageOrder(let imageOrder, let imageType):
            p["order"] = imageOrder
            p["type"] = imageType
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .inviteFriend(let name, let email):
            p["name"] = name
            p["email"] = email
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .supportRequest(let request, let reason):
            p["request"] = request
            p["reason"] = reason
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .updateBankDetails(let name, let sortcode, let accountNumber, let ibanNumber):
            var parameters = [String: Any]()
            parameters["bank_accountname"] = name
            parameters["bank_sortcode"] = sortcode
            parameters["bank_accountnumber"] = accountNumber
            parameters["bank_iban"] = ibanNumber
            p["parameters"] = parameters
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .rejectOption(let jobId):
            p["jobid"] = jobId
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .acceptJob(let jobId):
             p["jobid"] = jobId
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .rejectJob(let jobId):
            p["jobid"] = jobId
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .cancelJob(let jobId):
            p["jobid"] = jobId
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .completeJob(let jobId):
            p["jobid"] = jobId
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .updateDeviceToken(let deviceToken):
            p["deviceToken"] = deviceToken
            p["deviceType"] = "ios"
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .userDetails:
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .negotiateRate(let jobId, let newRate, let reasons):
            p["jobid"] = jobId
            p["rate"] = newRate
            p["reasons"] = reasons
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .updateAvailability(let availability):
            p["availability"] = availability
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)

        case .getCalendar:
            var components = DateComponents()
            
            // one month back, from first day of the month
            components.month = -1
            let start = Calendar.current.date(byAdding: components, to: Date())?.startOfMonth()
            
            // to 3 months ahead, to last day of the month
            components.month = 3
            let end = Calendar.current.date(byAdding: components, to: Date())?.endOfMonth()
            
            p["start"] = start?.timeIntervalSince1970
            p["end"] = end?.timeIntervalSince1970
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
        case .getCalendarEntriesForDate(let date):
            p["date"] = date
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)

        case .newCalendarEntry(let title, let allday, let starttime, let endtime, let location, let state, let isediting):
            p["title"] = title
            p["isAllDay"] = allday
            p["isReadOnly"] = false
            p["starttime"] = starttime
            p["endtime"] = endtime
            p["category"] = allday ? "allday" : "time"
            p["dueDateClass"] =  ""
            p["eventLocation"] = location
            p["state"] =  state
            p["isedit"] = isediting
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)

        case .deleteCalendarEntry(let scheduleid):
            p["scheduleid"] = scheduleid
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .updateCalendarEntry(let scheduleId, let title, let allday, let starttime, let endtime, let location, let state):
            p["title"] = title
            p["isAllDay"] = allday
            p["isReadOnly"] = false
            p["starttime"] = starttime
            p["endtime"] = endtime
            p["category"] = allday ? "allday" : "time"
            p["dueDateClass"] =  ""
            p["eventLocation"] = location
            p["state"] =  state
            p["scheduleid"] = scheduleId
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .getLastMinute:
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .setLastMinute(let availability):
            p["availability"] = availability
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .getReferrals:
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)

        case .getCommunityPosts:
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .login:
            return .none
        default:
            return .bearer
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

func FindaAPISession(target: FindaAPI, completion: @escaping (_ response: Bool, _ result: JSON) -> ()) {
    FindaAPIManager.request(target) { (result) in
        switch result {
        case .success(let response):
            do {
                let data = try response.mapJSON()
                let json = JSON(data)
                if json["errorMessage"].string == "Authentication token is invalid" {
                    LoginManager.signOut()
                }
                if json["status"] == 1 {
                    completion(true, json)
                    return
                }
                completion(false, json)
            } catch(_) {
                do {
                    if try response.mapString() == "Missing token" {
                        LoginManager.signOut()
                    }
                } catch(_) {}
                completion(false, JSON.null)
            }
        case .failure(_):
            completion(false, JSON.null)
            break
        }
    }
}

fileprivate func accessToken() -> String {
    let defaults = UserDefaults.standard
    guard let token = defaults.object(forKey:"access_token_auth") as? String else {
        return ""
    }
    return token
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

struct VerbosePlugin: PluginType {
    let verbose: Bool

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let body = request.httpBody,
           let str = String(data: body, encoding: .utf8) {
            if verbose {
                print("Request to send: \(str))")
            }
        }
        return request
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        switch result {
        case .success(let body):
            if verbose {
                print("Response:")
                if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
                    print(json)
                } else {
                    let response = String(data: body.data, encoding: .utf8)!
                    print(response)
                }
            }
        case .failure( _):
            break
        }
    }
    
}
