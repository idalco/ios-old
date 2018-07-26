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
    
    struct FindaColors {
        static let Blue = UIColor(rgb: 0x65b8bc)
        static let BrightBlue = UIColor(rgb: 0x01ebd2)
        static let Yellow = UIColor(rgb: 0xfcec03)
        static let DarkYellow = UIColor(rgb: 0xebca01)
        static let Purple = UIColor(rgb: 0x812d82)
        static let FindaRed = UIColor(rgb: 0xb8142b)
        static let FindaGreen = UIColor(rgb: 0x00dc8d)
        static let LightGrey = UIColor(rgb: 0xf4f4f4)
        static let BorderGrey = UIColor(rgb: 0xe6e6e6)
        static let Grey = UIColor(rgb: 0x7f7f7f)
        static let White = UIColor(rgb: 0xFFFFFF)
        static let Black = UIColor(rgb: 0x000000)
    }
    
    func alpha() -> UIColor {
        return self.withAlphaComponent(0.95)
    }
}
