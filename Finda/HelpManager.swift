//
//  HelpManager.swift
//  Finda
//

import Foundation
import UIKit

final class HelpManager {
    fileprivate var dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    // data models
    let faqURL: String = "https://www.finda.co/m.faq"
    let termsURL: String = "https://www.finda.co/m.terms"
    let privacyURL: String = "https://www.finda.co/m.privacy"
    
//    let onboardingPages: [UIImage] = [
//        UIImage(named: "tutorial1")!,
//        UIImage(named: "tutorial2")!,
//        UIImage(named: "tutorial3")!,
//        UIImage(named: "tutorial4")!,
//        UIImage(named: "tutorial5")!
//    ]
    
}

extension HelpManager {
    //    MARK:- Public API
    //    These methods should be custom tailored to read specific data subsets,
    //    as required for specific views. These will be called by Coordinators,
    //    then routed into UIViewControllers
    
    
}


fileprivate extension HelpManager {
    //    MARK:- Private API
    //    These are thin wrappers around DataManager‘s similarly named methods.
    //    They are used to process received data and splice and dice them as needed,
    //    into business logic that only CatalogManager knows about
    
    
}
