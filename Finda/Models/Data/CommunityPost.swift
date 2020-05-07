
//
//  CommunityPost.swift
//  Finda
//
//  Created by Tom Gordon on 20/04/2020.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CommunityPost {

    var id: Int = 0
    var timestamp: Int = 0
    var subject: String = ""
    var message: String = ""
    
    init(data: JSON) {
        self.id = data["id"].intValue
        self.subject = data["subject"].stringValue
        self.message = data["message"].stringValue
        self.timestamp = data["timestamp"].intValue
    }
    
    init() {
        self.id = 0
        self.subject = ""
        self.message = ""
        self.timestamp = 0
    }
}

