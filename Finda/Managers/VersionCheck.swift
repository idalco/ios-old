//
//  VersionCheck.swift
//  Finda
//
//  Created by cro on 20/06/2019.
//  Copyright © 2019 Finda Ltd. All rights reserved.
//

import Foundation
import Alamofire

class VersionCheck {
    
    public static let shared = VersionCheck()
    
    var newVersionAvailable: Bool?
    var appStoreVersion: String?
    
    func checkAppStore(callback: ((_ versionAvailable: Bool?, _ version: String?)->Void)? = nil) {
        let ourBundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        AF.request("https://itunes.apple.com/lookup?bundleId=\(ourBundleId)&country=gb").responseJSON { response in
            var isNew: Bool?
            var versionStr: String?
            
            switch response.result {
            case let .success(value):
                let json = value as! NSDictionary
                let results = json["results"] as! NSArray
                let entry = results.firstObject as! NSDictionary
                let appVersion = entry["version"] as? String
                let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                isNew = ourVersion != appVersion
                versionStr = appVersion
                self.appStoreVersion = versionStr
                self.newVersionAvailable = isNew
                callback?(isNew, versionStr)
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
