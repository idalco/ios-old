//
//  JobsManager.swift
//  Finda
//
//  Created by Peter Lloyd on 01/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class JobsManager {
    
    enum JobTypes: String {
        case all = "all"
        case offered = "offered"
        case requested = "requested"
        case optioned = "optioned"
        case accepted = "accepted"
        case expired = "expired"
        case completed = "completed"
        case rejected = "rejected"
        case finished = "finished"
        case unfinalised = "unfinalised"
        case confirmed = "confirmed"
        
    }
    
    static func getJobs(jobType: JobTypes, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .getJobs(jobType: jobType)) { (response, result) in
            if(response){
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
    static func length(length: Float, unit: String) -> String {
        var string = ""
        if (length == 0.5) {
            string = "1/2  \(unit)"
        } else if length == 0.25 {
            string = "1/4  \(unit)"
        } else {
            string = "\(length) \(unit)"
        }
        if (length > 1) {
            return "\(string)s"
        }
        return string
    }
}
