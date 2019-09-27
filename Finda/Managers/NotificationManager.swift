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

    static func getChatMessages(sender: Int, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .getChatMessages(sender: sender)) { (response, result) in
            if(response){
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
    static func sendChatMessage(recipient: Int, message: String, subject: String, type: Int, completion: @escaping (_ response: Bool, _ result: JSON) -> ()) {
        FindaAPISession(target: .sendChatMessage(recipient: recipient, message: message, subject: subject, type: type)) { (response, result) in
            if(response){
                completion(response, result)
                return
            }
            completion(false, result)
        }
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
    

    static func countNotifications(notificationType: NotificationTypes, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .countNotifications(notificationType: notificationType)) { (response, result) in
            if(response){
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
    
    static func deleteNotifications(id: Int, completion: @escaping (_ response: Bool, _ result: JSON) -> ()){
        FindaAPISession(target: .deleteNotifications(id: id)) { (response, result) in
            if(response){
                completion(response, result)
                return
            }
            completion(false, result)
        }
    }
    
    static func deleteNotifications(id: Int) {
        FindaAPISession(target: .deleteNotifications(id: id)) { (response, result) in }
    }
    
    static func flagNotifications(id: Int) {
        FindaAPISession(target: .flagNotifications(id: id)) { (response, result) in }
    }
    
}
