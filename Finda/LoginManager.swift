//
//  LoginManager.swift
//  Finda
//

import Foundation
import Moya
import Strongbox
import Flurry_iOS_SDK

public enum LoginProvider: String {
    case finda = "normal"
}


public struct LoginCredentials {
    var email: String
    var password: String?
    var token: String?
}

enum LoginError: Error {
    case noSavedCredentials
    case invalidCredentials
    case insuffientInput
}


final class LoginManager {
    
    enum Status: String {
        case noCredentials
        case loggedOutSavedCredentials
        case loggedIn
    }
    
    public var authToken: String?
    var status: Status = .noCredentials
    
    fileprivate var creds: LoginCredentials?
    fileprivate var provider: LoginProvider?
    fileprivate let api: FindaService
    fileprivate let dataManager: DataManager
    fileprivate let strongbox = Strongbox()
    fileprivate let USERNAME_KEY = "USERNAME"
    fileprivate let PASSWORD_KEY = "PASSWORD"
    fileprivate let PROVIDER_KEY = "PROVIDER"
    fileprivate let PROVIDER_TOKEN_KEY = "PROVIDER_TOKEN"
    fileprivate let TOKEN_KEY = "TOKEN"
    
    
    init(api: FindaService, dataManager: DataManager, shouldClearKeychain: Bool) {
        self.api = api
        self.dataManager = dataManager
        
        if shouldClearKeychain {
            clearKeychain()
        }
        
        // try and pull any saved credentials
        if let loginCreds = retrieveStoredCreds()
        {
            creds = loginCreds
            provider = retrieveLoginProvider()
            status = .loggedOutSavedCredentials
        }
    }
    
    func loginWithSavedCreds(callback: @escaping (_ success: Bool, _ response: LoginResponse?, _ error: Error?) -> Void) {
        if status == .loggedOutSavedCredentials {
            doLogin(provider: provider!, email: creds!.email, password: creds!.password, token: creds!.token, callback: callback)
        } else {
            callback(false, nil, LoginError.noSavedCredentials)
        }
    }
    
    func loginWithProvider(provider: LoginProvider, email: String, password: String?, token: String?, callback: @escaping (_ success: Bool, _ response: LoginResponse?, _ error: Error?) -> Void) {
        doLogin(provider: provider, email: email, password: password, token: token, callback: callback)
    }
    
    func registerAccount(name: String, email: String, password: String, callback: @escaping (_ success: Bool, _ response: RegisterResponse?, _ error: Error?) -> Void ) {
        api.register(name: name, email: email, password: password, success: { (response) in
            self.storeAuthToken(token: response.token!)
            self.storeLoginCreds(creds: LoginCredentials(email: email, password: password, token: nil))
            self.storeLoginProvider(provider: LoginProvider.finda)
            self.status = .loggedIn
            
            // send system-wide notification with new user object (so ui can be filled in)
            self.dataManager.fetchCurrentUser(callback: {(user, error) in
                if let user = user {
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.post(name: .userLoggedIn, object: user)
                }
            })
            
            let articleParams = ["token": response.token!];
            Flurry.logEvent("login", withParameters: articleParams);
            
            print("Registration successful!")
            callback(true, response, nil)
        }, failure: { (error) in
            print("Unable to register: /(error)")
            callback(false, nil, error)
        })
    }
    
    func clearKeychain() {
        removeAuthToken()
        removeLoginCreds()
        removeLoginProvider()
    }
    
    func logout() {
        clearKeychain()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: .userLoggedOut, object: nil)
        
        status = .noCredentials
    }
}

fileprivate extension LoginManager {
    func doLogin(provider: LoginProvider, email: String, password: String?, token: String?, callback: @escaping (_ success: Bool, _ response: LoginResponse?, _ error: Error?) -> Void) {
        
        // form correct creds for provider
        var requestUsername: String? = email
        var requestPassword: String? = password
        
        switch provider {
            case .finda:
                break
        }
        
        if let requestUsername = requestUsername, let requestPassword = requestPassword {
            // do login if we have the creds we need
            api.authenticate(email: requestUsername, password: requestPassword, type: provider.rawValue, success: { (loginResponse) in
                
                // save token
                self.storeAuthToken(token: loginResponse.token!)
                self.storeLoginCreds(creds: LoginCredentials(email: email, password: password, token: token))
                self.storeLoginProvider(provider: provider)
                self.status = .loggedIn
                
                print("Login successful!")
                
                // send login notification
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: .userLoggedIn, object: loginResponse.userData)
                
                // fire callback
                callback(true, loginResponse, nil)
                
                
            }, failure: { (error) in
                // fire callback
                print("Unable to login: \(error)")
                callback(false, nil, error)
            })
            
        } else {
            // throw error because of missing details
            callback(false, nil, LoginError.insuffientInput)
        }
 
    }
    
    func retrieveAuthToken() -> String? {
        let token = strongbox.unarchive(objectForKey: TOKEN_KEY) as! String?
        
        return token
    }
    
    func retrieveStoredCreds() -> LoginCredentials? {

        guard let email = strongbox.unarchive(objectForKey: USERNAME_KEY) as? String else {
            return nil
        }
        let password = strongbox.unarchive(objectForKey: PASSWORD_KEY) as? String
        let token = strongbox.unarchive(objectForKey: PROVIDER_TOKEN_KEY) as? String
        
        return LoginCredentials(email: email, password: password, token: token)
    }
    
    func retrieveLoginProvider() -> LoginProvider? {
        if let providerRaw = strongbox.unarchive(objectForKey: PROVIDER_KEY) as! String? {
            return LoginProvider(rawValue: providerRaw)
        } else {
            return nil
        }
    }
    
    func storeAuthToken(token: String) {
        // set as our active token
        self.authToken = token
        
        // store in keychain
        if !strongbox.archive(token, key: TOKEN_KEY) {
            print("Error storing token") // TODO: throw exception here
        }
    }
    
    func storeLoginCreds(creds: LoginCredentials) {
        if !strongbox.archive(creds.email, key: USERNAME_KEY) || !strongbox.archive(creds.password, key: PASSWORD_KEY) || !strongbox.archive(creds.token, key: PROVIDER_TOKEN_KEY){
            print("Error storing creds") // TODO: throw exception here
        }
    }
    
    func storeLoginProvider(provider: LoginProvider) {
        if !strongbox.archive(provider.rawValue, key: PROVIDER_KEY) {
            print("Error storing provider") // TODO: throw exception here
        }
    }
    
    func removeAuthToken() {
        if !strongbox.archive(nil, key: TOKEN_KEY){
            print("Error removing auth token") // TODO: throw exception here
        }
    }
    
    func removeLoginCreds() {
        if !strongbox.archive(nil, key: USERNAME_KEY) || !strongbox.archive(nil, key: PASSWORD_KEY) || !strongbox.archive(nil, key: PROVIDER_TOKEN_KEY){
            print("Error removing login creds") // TODO: throw exception here
        }
    }
    
    func removeLoginProvider() {
        if !strongbox.archive(nil, key: PROVIDER_KEY){
            print("Error removing login provider") // TODO: throw exception here
        }
    }
}
