//
//  ReachabilityManager.swift
//  Finda
//

import Foundation
import Alamofire

final class ReachabilityManager {
    
    private var reachable = true
    private var connectionType: NetworkReachabilityManager.NetworkReachabilityStatus?
    private let manager: NetworkReachabilityManager! = NetworkReachabilityManager(host: "api.finda.co")
    
    required init() {
        
        manager.listener = { status in
            
            print("Network Status Changed: \(status)")
            print("network reachable \(self.manager!.isReachable)")
            
            self.reachable = self.manager.isReachable
            self.connectionType = status
            
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: .reachabilityChanged, object: status)
        }
        
        manager.startListening()
    }
    
    deinit {
        manager.stopListening()
    }
    
    public func isOnline() -> Bool {
        let online = reachable
        
        return online
    }
}
