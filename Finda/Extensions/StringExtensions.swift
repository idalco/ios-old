//
//  StringExtensions.swift
//  Finda
//
//  Created by Peter Lloyd on 28/07/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    func htmlAttributed(family: String?) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}" +
//                " a, a:visited, a:active, a:focus { color: #F0F !imporant; }" +
            "</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
            
            
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func range(substring: String) -> NSRange{
        if let substringRange = self.range(of: substring) {
            return NSRange(substringRange, in: self)
        }
        return NSRange()
        
        
    }

}

