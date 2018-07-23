//
//  AccountError.swift
//   Finda
//

import Foundation

public enum AccountError: Error {
    //    case network(NetworkError?)
    case notLoggedIn
    case custom(String)
}

extension AccountError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notLoggedIn:
            return "No user is logged in."
        case .custom(let reason):
            return reason
        }
    }
}
