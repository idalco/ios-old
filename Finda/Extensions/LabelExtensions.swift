//
//  LabelExtensions.swift
//  Finda
//
//  Created by Peter Lloyd on 31/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.underlineColor, value: UIColor.FindaColours.Yellow, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
