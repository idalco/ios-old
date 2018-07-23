//
//  RegisterResponse.swift
//  Finda
//

import Foundation
import Marshal
import Moya_Marshal

final class RegisterResponse: NSObject, Unmarshaling {
    
    let status: Int
    let token: String?
    let errorMessage: String?
    
    init (status: Int, token: String?, errorMessage: String?) {
        self.status = status
        self.token = token
        self.errorMessage = errorMessage
    }
    
    init(object: MarshaledObject) throws {
        status = try object.value(for: "status")
        token = try object.value(for: "token")
        errorMessage = try object.value(for: "error")
    }
}
