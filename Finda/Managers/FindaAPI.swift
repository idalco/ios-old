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
    
    
    
    

    case register(email: String, password: String, name: String, locale: String)
    case updateProfile(email: String, firstName: String, lastName: String)
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
            
            
            
        case .register:
            return "/register"
        case .updateProfile:
            return "/updateProfile"
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
        case .login, .termData, .logout, .registerModel, .registerClient, .register, .updateProfile, .updateDeviceToken, .updateAvatar:
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
            p["country"] = country
            p["usertype"] = "brand"
            p["agree_terms"] = 1
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)

            
        case .getJobs(let jobType):
            p["type"] = jobType.rawValue
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

