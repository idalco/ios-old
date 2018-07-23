//
//  FindaServiceError.swift
//  Finda
//

import Foundation


public enum FindaServiceError: Error {
//    case network(NetworkError?)
    case notYetAuthenticated
    case requestNotAuthorised
    case invalidResponseType
    case emptyResponse
    case unexpectedResponse(HTTPURLResponse, String?)
    case serviceNotAvailable
    case custom(String)
}

extension FindaServiceError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notYetAuthenticated:
            return "Unable to perform request - not yet authenticated."
        case .requestNotAuthorised:
            return "Request was not authorised by server. Perhaps token has expired."
        case .invalidResponseType:
            return "Invalid response type"
        case .emptyResponse:
            return "Response from server was empty!"
        case .unexpectedResponse:
            return "Unexpected response from server!"
        case .serviceNotAvailable:
            return "API not available from AppDependencies"
        case .custom(let reason):
            return reason
        }
    }
}
