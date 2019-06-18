//
//  UIColor+TMAColours.swift
//  Finda
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    struct FindaColours {
//        static let Blue = UIColor(rgb: 0x65b8bc)
//        static let OldBlue = 59C5CF
        static let Blue = UIColor(rgb: 0x13AFC0)
        static let BrightBlue = UIColor(rgb: 0x59E7F7)
        static let Yellow = UIColor(rgb: 0xffba1c)
        static let DarkYellow = UIColor(rgb: 0xffba1c)
        static let Purple = UIColor(rgb: 0xC353E3)
        static let FindaRed = UIColor(rgb: 0xEA546A)
        static let FindaGreen = UIColor(rgb: 0x00DD00)
        static let LightGrey = UIColor(rgb: 0xCFDCDA)   // lightgreen now
        static let BorderGrey = UIColor(rgb: 0xe6e6e6)
        static let Grey = UIColor(rgb: 0x99A3A3)
        static let White = UIColor(rgb: 0xFEFEFE)
        static let Black = UIColor(rgb: 0x565c66)
        static let Pink = UIColor(rgb: 0xd71e82)
        static let LightGreen = UIColor(rgb: 0xd5e1df)
        static let LighterGreen = UIColor(rgb: 0xdde7e5)
        static let PaleGreen = UIColor(rgb: 0xE7EDED)
    }
    
    func fade(alpha:CGFloat = 0.05) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
    func lighter(by percentage: CGFloat = 0.95) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 0.95) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
