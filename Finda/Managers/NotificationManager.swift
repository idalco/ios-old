//
//  NotificationManager.swift
//  Finda
//
//  Created by Peter Lloyd on 06/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationManager {
    
    enum NotificationTypes: String {
        case all = "all"
        case new = "new"

    }

    static func getNotifications(notificationType: NotificationTypes, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .getNotifications(notificationType: notificationType)) { (response, result) in
            if(response){
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
}
