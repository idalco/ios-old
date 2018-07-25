//
//  LoginManager.swift
//  Finda
//
//  Created by Peter Lloyd on 25/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import Marshal

class LoginManager {
    
    enum LoginStatus: Int {
        
        case Unverified = 0
        case verified = 1
        case Banned = 2
        case Special = 99
    }
    
    init(){
        
    }
    
    func login(email: String, password: String, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPIManager.request(.login(email: email, password: password)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    let json = JSON(data)
                    completion(true, json)
                } catch(_){
                    
                }
            case .failure(_):
                break
            }
        }
    }
    
}

