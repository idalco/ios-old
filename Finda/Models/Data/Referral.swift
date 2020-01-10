//
//  Referral.swift
//  Finda
//
//  Created by Peter Lloyd on 14/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class Referral {
    
    var firstname: String
    var lastname: String
    var avatar: String
    var status: Int
    
    init(data: JSON) {
        self.firstname = data["firstname"].stringValue
        self.lastname = data["lastname"].stringValue
        self.avatar = data["avatar"].stringValue
        self.status = data["status"].intValue
    }
    
}
