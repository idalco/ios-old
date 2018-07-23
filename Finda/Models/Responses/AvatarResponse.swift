//
//  AvatarResponse.swift
//  Finda
//

import Foundation
import Marshal
import Moya_Marshal

final class AvatarResponse: NSObject, Unmarshaling {
    
    let status: Int
    let errorMessage: String?
    let data: String?
    
    init (status: Int, errorMessage: String?, data: String?) {
        self.status = status
        self.errorMessage = errorMessage
        self.data = data
    }
    
    init(object: MarshaledObject) throws {
        status = try object.value(for: "status")
        errorMessage = try object.value(for: "errorMessage")
        data = try object.value(for: "avatar")
    }
}
