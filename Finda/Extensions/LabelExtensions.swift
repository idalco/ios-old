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
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.underlineColor, value: UIColor.FindaColours.Yellow, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    

    func addImageWith(name: String, behindText: Bool, isSystemName: Bool) {

        let attachment = NSTextAttachment()
        if isSystemName {
            if #available(iOS 13.0, *) {
                attachment.image = UIImage(systemName: name)
            } else {
                // Fallback on earlier versions
                attachment.image = UIImage(named: name)
            }
        } else {
            attachment.image = UIImage(named: name)
        }
        let attachmentString = NSAttributedString(attachment: attachment)

        guard let txt = self.text else {
            return
        }

        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }

    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
