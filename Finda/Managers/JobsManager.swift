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
        case accepted = "accepted"
        case expired = "expired"
        case completed = "completed"
        case rejected = "rejected"
        case finished = "finished"
        case unfinalised = "unfinalised"
        
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
    
    static func length(length: Int, unit: String) -> String {
        let string = "\(length) \(unit)"
        if (length > 1) {
            return "\(string)s"
        }
        return string
    }
}
