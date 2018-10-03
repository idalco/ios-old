//
//  BaseCellExtensions.swift
//  Finda
//
//  Created by Peter Lloyd on 26/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import Eureka

extension BaseCell {
    func setBottomBorder(colour: UIColor = UIColor.FindaColours.Black) {
    
        
        self.layer.backgroundColor = self.superview?.backgroundColor?.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = colour.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
