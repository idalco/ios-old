//
//  AppDependency.swift
//  Finda
//

import Foundation
import Coordinator
import CoreData


//    Dummy objects, placeholders for real ones
final class Keychain {}

//    Dependency carrier through the app,
//    injected into every Coordinator
struct AppDependency {
    var apiManager: FindaService?
    var dataManager: DataManager?
    var loginManager: LoginManager?
    var keychainProvider: Keychain?
    var helpManager: HelpManager?
    var accountManager: AccountManager?
    
    init(apiManager: FindaService? = nil,
         dataManager: DataManager? = nil,
         loginManager: LoginManager? = nil,
         keychainProvider: Keychain? = nil,
         helpManager: HelpManager? = nil,
         accountManager: AccountManager? = nil)
    {

        self.apiManager = apiManager
        self.loginManager = loginManager
        self.keychainProvider = keychainProvider
        self.dataManager = dataManager
        self.helpManager = helpManager
        self.accountManager = accountManager
    }
}

final class AppDependencyBox: NSObject {
    let unbox: AppDependency
    init(_ value: AppDependency) {
        self.unbox = value
    }
}

extension AppDependency {
    var boxed: AppDependencyBox { return AppDependencyBox(self) }
}
