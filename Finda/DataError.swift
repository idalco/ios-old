//
//  DataError.swift
//  Finda
//

import Foundation
import Marshal

enum DataError: Error {
    case internalError
    case insufficientInput
    case missingData
//    case noDestinations
    
//    case finda(FindaServiceError)
    case marshalError(MarshalError)
}


extension DataError: CustomStringConvertible {
    var description: String {
        switch self {
        case .internalError:
            return "Internal Error"
        case .insufficientInput:
            return "Insufficient input parameters"
        case .missingData:
            return "No data available at the moment"
//        case .noDestinations:
//            return "No destinations available"
//        case .findaServiceError:    //TODO: improve this
//            return "Internal error"
        case .marshalError:
            return "Data parsing error"
        }
    }
}
