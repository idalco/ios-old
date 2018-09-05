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
    
    func af_setImage(withPortfolioSourceURL: URL, imageTransition: ImageTransition = .noTransition, completion: @escaping ((Bool) -> Void)){
        if let url = URL(string: "\(domainURL)/portfolio/source\(withPortfolioSourceURL.absoluteString)"){
            self.af_setImage(withURL: url, imageTransition: imageTransition) { (response) in
                if((response.value) != nil) {
                    completion(true)
                } else {
                    completion(false)
                }
            }

            
        }
    }
    
    func af_setImage(withPolaroidsSourceURL: URL, imageTransition: ImageTransition = .noTransition, completion: @escaping ((Bool) -> Void)){
        if let url = URL(string: "\(domainURL)/polaroids/source\(withPolaroidsSourceURL.absoluteString)"){
            self.af_setImage(withURL: url, imageTransition: imageTransition) { (response) in
                if((response.value) != nil) {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func af_setImage(withAvatarURL: URL, imageTransition: ImageTransition = .noTransition){
        if let url = URL(string: "\(domainURL)/avatar/thumb\(withAvatarURL.absoluteString)"){
            self.af_setImage(withURL: url, imageTransition: imageTransition)
        }
    }
}

