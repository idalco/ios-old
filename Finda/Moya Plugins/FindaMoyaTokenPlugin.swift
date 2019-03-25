import Foundation
import Result
import Moya

// MARK: - FindaTokenPlugin


/**
 A plugin for adding necessary Token header to Finda API requests
 ```
 
 */
public struct FindaTokenPlugin: PluginType {
    
    /// A closure returning the access token to be applied in the header.
    public let tokenClosure: () -> String
    
    /**
     Initialize a new `FindaTokenPlugin`.
     
     - parameters:
     - tokenClosure: A closure returning the token to be applied in the pattern `Token: <token>`
     */
    public init(tokenClosure: @escaping @autoclosure () -> String) {
        self.tokenClosure = tokenClosure
    }
    
    /**
     Prepare a request by adding an authorization header if necessary.
     
     - parameters:
     - request: The request to modify.
     - target: The target of the request.
     - returns: The modified `URLRequest`.
     */
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authorizable = target as? AccessTokenAuthorizable else { return request }
        
        let authorizationType = authorizable.authorizationType
        
        var request = request
        
        switch authorizationType {
            case .basic, .bearer:
                request.addValue(tokenClosure(), forHTTPHeaderField: "Token")
            case .none:
                break
            case .custom(_):
                break
        }
        
        return request
    }
}

