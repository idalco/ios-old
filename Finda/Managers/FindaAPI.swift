//
//  FindaAPI.swift
//  Finda
//

import Foundation
import Moya
import Moya_Marshal

let FindaAPIManager = MoyaProvider<FindaAPI>( plugins: [
    NetworkLoggerPlugin(verbose: true),
    FindaHMACPlugin(),
    FindaTokenPlugin(tokenClosure: "")
    ])


enum FindaAPI {
    // POST
    case login(email: String, password: String)
    case logout()
    case register(email: String, password: String, name: String, locale: String)
    case updateProfile(email: String, firstName: String, lastName: String)
    case updateDeviceToken(deviceToken: String, deviceType: String)
    // POST Multipart
    case updateAvatar(avatar: UIImage)
    // GET
    case userDetails()
}

extension FindaAPI: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL { return URL(string: "http://dev.finda.co/api/1.0")! }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .logout:
            return "/logout"
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
        case .login, .logout, .register, .updateProfile, .updateDeviceToken, .updateAvatar:
            return .post
            
        // methods requiring GET
        case .userDetails:
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
        
        case .register(let email, let password, let name, let locale):
            p["email"] = email
            p["password"] = password
            p["name"] = name
            p["locale"] = locale
            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
        
//        case .updateProfile(let firstName, let lastName, let email):
//            p["username"] = username
//            p["firstname"] = firstName
//            p["lastname"] = lastName
//            p["email"] = email
//            return .requestParameters(parameters: p, encoding: URLEncoding.queryString)
            
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
//
//func FindaAPISession(target: FindaAPI) {
//    FindaAPIManager.request(target) { (result) in
//        switch result {
//        case .success(let response):
//           print(result)
//
//        case .failure(_):
//            break
//        }
//    }
//}
//

