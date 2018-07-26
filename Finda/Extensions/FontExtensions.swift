////
////  FontExtensions.swift
////  Finda
////
////  Created by Peter Lloyd on 26/07/2018.
////  Copyright © 2018 Finda Ltd. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//extension UILabel {
//    public var substituteFontName : String {
//        get {
//            return self.font.fontName;
//        }
//        set {
//            let fontNameToTest = self.font.fontName.lowercased();
//            var fontName = newValue;
//            if fontNameToTest.range(of: "bold") != nil {
//                fontName += "-Bold";
//            } else if fontNameToTest.range(of: "medium") != nil {
//                fontName += "-Medium";
//            } else if fontNameToTest.range(of: "light") != nil {
//                fontName += "-Light";
//            } else if fontNameToTest.range(of: "ultralight") != nil {
//                fontName += "-UltraLight";
//            }
//            self.font = UIFont(name: fontName, size: self.font.pointSize)
//        }
//    }
//}
//
//extension UITextView {
//    public var substituteFontName : String {
//        get {
//            return self.font?.fontName ?? "";
//        }
//        set {
//            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
//            var fontName = newValue;
//            if fontNameToTest.range(of: "bold") != nil {
//                fontName += "-Bold";
//            } else if fontNameToTest.range(of: "medium") != nil {
//                fontName += "-Medium";
//            } else if fontNameToTest.range(of: "light") != nil {
//                fontName += "-Light";
//            } else if fontNameToTest.range(of: "ultralight") != nil {
//                fontName += "-UltraLight";
//            }
//            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
//        }
//    }
//}
//
//extension UITextField {
//    public var substituteFontName : String {
//        get {
//            return self.font?.fontName ?? "";
//        }
//        set {
//            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
//            var fontName = newValue;
//            if fontNameToTest.range(of: "bold") != nil {
//                fontName += "-Bold";
//            } else if fontNameToTest.range(of: "medium") != nil {
//                fontName += "-Medium";
//            } else if fontNameToTest.range(of: "light") != nil {
//                fontName += "-Light";
//            } else if fontNameToTest.range(of: "ultralight") != nil {
//                fontName += "-UltraLight";
//            }
//            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
//        }
//    }
//}
