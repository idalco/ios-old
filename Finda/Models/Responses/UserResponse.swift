//
//  UserResponse.swift
//  Finda
//

import Foundation
import Marshal
import Moya_Marshal

final class UserResponse: NSObject, Unmarshaling {
    
    let status: Int
    let data: User?
    let errorMessage: String?
    
    init (status: Int, data: User?, errorMessage: String?) {
        self.status = status
        self.data = data
        self.errorMessage = errorMessage
    }
    
    init(object: MarshaledObject) throws {
        status = try object.value(for: "status")
        data = try object.value(for: "userdata")
        errorMessage = try object.value(for: "errorMessage")
    }
}
