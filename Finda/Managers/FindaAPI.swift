//
//  FindaAPI.swift
//  Finda
//

import Foundation
import Moya
import SwiftyJSON


let FindaAPIManager = MoyaProvider<FindaAPI>( plugins: [
    NetworkLoggerPlugin(verbose: true),
    FindaHMACPlugin(),
    FindaTokenPlugin(tokenClosure: accessToken())
    ])

enum FindaAPI {
    // POST
    case login(email: String, password: String)
    case registerModel(mail: String, pass: String, firstname: String, lastname: String, gender: String, country: String, instagram_username: String, referral_code: String?, dob: TimeInterval)
    case registerClient(mail: String, pass: String, firstname: String, lastname: String, telephone: String, occupation: String, company_name: String, company_website: String, country: String)
    case termData(term: TermDataManager.TermData)
    case logout()
    case getJobs(jobType: JobsManager.JobTypes)
    case getNotifications(notificationType: NotificationManager.NotificationTypes)
    case countNotifications(notificationType: NotificationManager.NotificationTypes)
    case deleteNotifications(id: Int)
    case updateProfile(firstName: String, lastName: String, email: String, gender: String, ethnicityId: Int, instagramUsername: String, referralCode: String, vatNumber: String)
    case updateMeasurements(height: Int, bust: Int, waist: Int, hips: Int, shoeSize: Int, dressSize: Int, hairColour: Int, hairLength: Int, hairType: Int, eyeColour: Int, willingToColour: Int, willingToCut: Int)
    case updatePreferences(friend_registers: String, job_offered: String, job_cancelled: String, job_changed: String, payment_made: String, notifications: String)
    
    case uploadPortfolioImage(image: UIImage)
    case uploadPolaroidImage(image: UIImage)
    case getImages(type: ImageType)

    
    

    case register(email: String, password: String, name: String, locale: String)
        case updateDeviceToken(deviceToken: String, deviceType: String)
    // POST Multipart
    case updateAvatar(avatar: UIImage)
    // GET
    case userDetails()
}

let domainURL: String = "http://dev.finda.co"

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
            return "getNotifications"
        case .countNotifications:
            return "getNotifications"
        case .deleteNotifications:
            return "deleteNotification"
        case .updateProfile:
            return "/updateProfile"
        case .updateMeasurements:
            return "/updateProfile"
        case .updatePreferences:
            return "/updateProfile"
        case .uploadPortfolioImage:
            return "/uploadPortfolio"
        case .uploadPolaroidImage:
            return "/uploadPolaroid"
        case .getImages:
            return "/getImages"
            
            
            
            
        case .register:
            return "/register"
        
//        case .submitFeedback:
//            return "/sendFeedback"
        case .updateDeviceToken:
            return "/updateDeviceToken"
        case .updateAvatar:
            return "/updateAvatar"
        case .userDetails:
            return "/userLoad"
        }
    }
    
    var method: Moya.Method {
        switch self {
        
        // methods requiring POST
        case .login, .termData, .logout, .registerModel, .registerClient, .getNotifications, .countNotifications, .deleteNotifications, .updateProfile, .updateMeasurements, .updatePreferences, .uploadPortfolioImage, .uploadPolaroidImage, .getImages, .register, .updateDeviceToken, .updateAvatar:
            return .post
            
        // methods requiring GET
        case .userDetails, .getJobs:
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
        case .registerModel(let mail, let pass, let firstname, let lastname, let gender, let country, let instagram_username, let referral_code, let dob):
            p["email"] = mail
            p["password"] = pass
            p["firstname"] = firstname
            p["lastname"] = lastname
            p["gender"] = gender.lowercased()
            p["country"] = country
            p["usertype"] = "model"
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
        case .countNotifications(let notificationType):
            p["type"] = notificationType.rawValue
            p["count"] = true
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        case .deleteNotifications(let id):
            p["msgid"] = id
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        case .updateProfile(let firstName, let lastName, let email, let gender, let ethnicityId, let instagramUsername, let referralCode, let vatNumber):
            var parameters = [String: Any]()
            
            parameters["firstname"] = firstName
            parameters["lastname"] = lastName
            parameters["mail"] = email
            parameters["gender"] = gender
            parameters["ethnicity"] = ethnicityId
            parameters["instagram"] = instagramUsername
            if (referralCode != "") {
                parameters["referral_code"] = referralCode
            }
            if (vatNumber != "") {
                parameters["vat_number"] = vatNumber
            }
            
            p["parameters"] = parameters
            
         
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .updateMeasurements(let height, let bust, let waist, let hips, let shoeSize, let dressSize, let hairColour, let hairLength, let hairType, let eyeColour, let willingToColour, let willingToCut):
            var parameters = [String: Any]()
            parameters["height"] = height
            parameters["bust"] = bust
            parameters["waist"] = waist
            parameters["hips"] = hips
            parameters["shoesize"] = shoeSize
            parameters["dresssize"] = dressSize
            parameters["haircolour"] = hairColour
            parameters["hairlength"] = hairLength
            parameters["hairtype"] = hairType
            parameters["eyecolour"] = eyeColour
            parameters["willingtocolour"] = willingToColour
            parameters["willingtocut"] = willingToCut
            
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
            
            
        case .uploadPolaroidImage(let image):
            guard let jpegRep = UIImageJPEGRepresentation(image, 1.0) else { return .uploadMultipart([]) }
            let jpegData = MultipartFormData(provider: .data(jpegRep), name: "polaroids", fileName: "image.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([jpegData])
            
        case .uploadPortfolioImage(let image):
            guard let jpegRep = UIImageJPEGRepresentation(image, 1.0) else { return .uploadMultipart([]) }
            let jpegData = MultipartFormData(provider: .data(jpegRep), name: "portfolio", fileName: "image.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([jpegData])
            
        case.getImages(let type):
             p["imagetype"] = type.rawValue
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
            
        case .register(let email, let password, let name, let locale):
            p["email"] = email
            p["password"] = password
            p["name"] = name
            p["locale"] = locale
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .updateDeviceToken(let deviceToken, let deviceType):
            p["deviceToken"] = deviceToken
            p["deviceType"] = deviceType
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        case .updateAvatar(let avatar):
            guard let jpegRep = UIImageJPEGRepresentation(avatar, 1.0) else { return .uploadMultipart([]) }
            let jpegData = MultipartFormData(provider: .data(jpegRep), name: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([jpegData])
            
        case .userDetails():
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
        default:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .login, .register:
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
                if(json["errorMessage"].string == "Authentication token is invalid"){
                    LoginManager.signOut()
                }
                if(json["status"] == 1){
                    completion(true, json)
                    return
                }
                completion(false, json)
            } catch(_){
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

