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
    
    static func getJobs(jobType: JobTypes, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .getJobs(jobType: jobType)) { (response, result) in
            if(response){
                
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
}
