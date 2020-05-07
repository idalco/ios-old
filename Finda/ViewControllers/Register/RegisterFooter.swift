//
//  RegisterFooterVC.swift
//  Finda
//
//  Created by Peter Lloyd on 30/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import Eureka
import DCKit


class RegisterFooter {
    
    static func legalFooter(width: CGFloat) -> UITextView {
        let title = UITextView(frame: CGRect(x:10,y: 5, width:width - 20, height:130))
        title.isSelectable = true
        title.isEditable = false
        title.backgroundColor = UIColor.clear
        
        
        let attributedString = NSMutableAttributedString(string: "I agree to the Finda Terms & Conditions and Privacy Policy and the Stripe Connected Account Agreement. \n\nAll accounts registered with FINDA are subject to verification. Until verification is complete your access to FINDA will be limited to viewing your own profile.")
        
        
        attributedString.addAttribute(.link, value: "\(domainURL)/terms", range: NSRange(location: 15, length: 24))
        attributedString.addAttribute(.link, value: "\(domainURL)/privacy", range: NSRange(location: 44, length: 14))
        attributedString.addAttribute(.link, value: "https://stripe.com/gb/connect-account/legal", range: NSRange(location: 67, length: 34))
        
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.FindaColours.Black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineColor.rawValue): UIColor.FindaColours.Yellow,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineStyle.rawValue): NSUnderlineStyle.thick.rawValue]
        
        
        title.linkTextAttributes = linkAttributes
        title.attributedText = attributedString
        
        
        title.font = UIFont(name: "Montserrat-Light", size: 11)
        return title
    }
    
    static func signUpButton(width: CGFloat) -> UIButton {
        let button = DCBorderedButton(frame: CGRect(x: (width / 2) - (215 / 2), y: 130, width: 215, height: 45))
        button.setTitle("SIGN UP", for: .normal)
        
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        button.normalBackgroundColor = UIColor.FindaColours.Burgundy
        button.normalBorderColor = UIColor.FindaColours.Burgundy
        button.normalTextColor = UIColor.FindaColours.White
        button.cornerRadius = 2
        
        return button
    }
}


