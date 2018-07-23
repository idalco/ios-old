//
//  Help-CoordinatingResponder.swift
//  Finda
//

import UIKit


final class HelpPageBox: NSObject {
    let unbox: HelpCoordinator.Page
    init(_ value: HelpCoordinator.Page) {
        self.unbox = value
    }
}
extension HelpCoordinator.Page {
    var boxed: HelpPageBox { return HelpPageBox(self) }
}


extension UIResponder {
    
    //    ** Data requests by various VCs should bubble up to some of the Coordinators
    //    ** which will then contact DataManager, get the data and pass it back
    
    /// Returns the list of all currently promoted products
    ///
    /// - Parameters:
    ///   - sender: reference to object who requested data
    ///   - feedback: user's feedback to send
    ///   - completion: Closure to call when data is ready or error occurs
    @objc dynamic func submitFeedback(sender: Any?, feedback: String, completion: @escaping (Error?) -> Void) {
        coordinatingResponder?.submitFeedback(sender: sender, feedback: feedback, completion: completion)
    }
    
    
}
