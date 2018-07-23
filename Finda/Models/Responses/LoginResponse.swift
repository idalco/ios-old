//
//  LoginResponse.swift
//  Finda
//

import Foundation
import Marshal
import Moya_Marshal

final class LoginResponse: NSObject, Unmarshaling {

    let status: Int
    let token: String?
    let error: String?
    let userData: User
    
    init (status: Int, user: User, token: String?, error: String?) {
        self.status = status
        self.userData = user
        self.token = token
        self.error = error
    }
    
    init(object: MarshaledObject) throws {
        status = try object.value(for: "status")
        userData = try object.value(for: "data")
        token = try object.value(for: "token")
        error = try object.value(for: "error")
    }
}
