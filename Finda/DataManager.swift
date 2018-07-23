//
//  DataManager.swift
//  Finda
//

import Foundation
import Moya
import Moya_Marshal
import SVProgressHUD

final class DataManager {
    // dependencies
    let api: FindaService
    
    init(api: FindaService) {
        self.api = api
    }
    
    let serviceErrorCallback = {(error: FindaServiceError) in
        // server responded, but it wasn't what we hoped for
        print("Service Error: \(error.description)")
    }
    
    let requestFailureCallback = {(error: MoyaError) in
        // request didn't make it to the server
        print("Request Failure: \(error.errorDescription!)")
    }
}

extension DataManager {
    
    func saveAvatar(avatar: UIImage, callback: @escaping (Error?) -> Void) {
        api.request(target: .updateAvatar(avatar: avatar), success: {(response) in
            do {
                let avatarResponse = try response.map(to: AvatarResponse.self)
                if let avatar = avatarResponse.data {
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.post(name: NSNotification.Name.avatarChanged, object: avatar)
                }
            } catch {
                callback(error)
            }
            callback(nil)
        }, error: {(error) in
            callback(error)
        }, failure: {(error) in
            callback(error)
        })
    }
    
    func saveProfile(user: User, callback: @escaping (Error?) -> Void) {
        api.request(target: .updateProfile(email: user.email, firstName: user.firstName, lastName: user.lastName), success: {(response) in
            callback(nil)
        }, error: {(error) in
            callback(error)
        }, failure: {(error) in
            callback(error)
        })
    }
    
//    func saveSettings(user: User, callback: @escaping (Error?) -> Void) {
//        api.request(target: .updateSettings(), success: {(response) in
//            callback(nil)
//        }, error: {(error) in
//            callback(error)
//        }, failure: {(error) in
//            callback(error)
//        })
//    }
    
    func fetchCurrentUser(callback: @escaping (User?, Error?) -> Void) {

        api.request(target: .userDetails(), success: { (response) in
            do {
                let currentUserResponse = try response.map(to: UserResponse.self)
                
                // fire callback with CurrentUser if it's in the data, otherwise
                // fire callback with error instead
                guard let user = currentUserResponse.data else {
                    callback(nil, DataError.missingData)
                    return
                }
                callback(user, nil)
            } catch {
                print("Error fetching current user: \(error)")
                callback(nil, DataError.internalError)
            }
        }, error: { (error) in
            self.serviceErrorCallback(error)
            callback(nil, error)
        }, failure: { (error) in
            self.requestFailureCallback(error)
            callback(nil, error)
        })
    }
    
}
