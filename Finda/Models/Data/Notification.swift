//
//  Notification.swift
//  Finda
//
//  Created by Peter Lloyd on 06/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Notification {

    enum Status: Int {
        case New = 0;
        case Read = 1;
    }
    
    let id, jobid, timestamp, recipient, sender, status, type, job_status : Int
    let subject, message, firstname, lastname, avatar, sefu : String

    
    init(data: JSON) {
        self.id = data["id"].intValue
        self.jobid = data["jobid"].intValue
        self.subject = data["subject"].stringValue
        self.message = data["message"].stringValue
        self.timestamp = data["timestamp"].intValue
        self.recipient = data["recipient"].intValue
        self.sender = data["sender"].intValue
        self.firstname = data["firstname"].stringValue
        self.lastname = data["lastname"].stringValue
        self.avatar = data["avatar"].stringValue
        self.sefu = data["sefu"].stringValue
        self.status = data["status"].intValue
        self.type = data["type"].intValue
        self.job_status = data["job_status"].intValue
    }
}

