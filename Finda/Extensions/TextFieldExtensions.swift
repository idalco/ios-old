//
//  TextFieldExtensions.swift
//  Finda
//
//  Created by Peter Lloyd on 25/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setBottomBorder(colour: UIColor = UIColor.FindaColors.Black) {
        self.borderStyle = .none
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = colour.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setBottomBorderLogin(borderColor: CGColor = UIColor.black.cgColor,
                         backgroundColor: CGColor = UIColor.clear.cgColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = backgroundColor
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = borderColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}
