//
//  ImageExtension.swift
//  Finda
//
//  Created by Peter Lloyd on 25/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension UIImageView {
    func af_setImage(withPortfolioURL: URL, imageTransition: ImageTransition = .noTransition){
        if let url = URL(string: "\(domainURL)/portfolio/thumb\(withPortfolioURL.absoluteString)"){
            self.af_setImage(withURL: url, imageTransition: imageTransition)

        }
    }
    
    func af_setImage(withPolaroidsURL: URL, imageTransition: ImageTransition = .noTransition){
        if let url = URL(string: "\(domainURL)/polaroids/thumb\(withPolaroidsURL.absoluteString)"){
            self.af_setImage(withURL: url, imageTransition: imageTransition)
            
        }
        
    }
}

