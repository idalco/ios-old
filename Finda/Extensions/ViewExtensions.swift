//
//  ViewExtensions.swift
//  Finda
//
//  Created by Peter Lloyd on 05/08/2018.
//  Copyright © 2018 Finda Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setRounded(colour: CGColor? = nil) {
        
        let colour = colour ?? UIColor.clear.cgColor
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = colour
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
    
    func setRounded(radius: CGFloat, colour: CGColor? = nil) {
        
        let colour = colour ?? UIColor.clear.cgColor
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = colour
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    static func reuseIdentifier() -> String {
        return NSStringFromClass(classForCoder()).components(separatedBy: ".").last!
    }
    
    static func UINibForClass(_ bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: reuseIdentifier(), bundle: bundle)
    }
    
    static func nibForClass() -> Self {
        return loadNib(self)
        
    }
    
    static func loadNib<A>(_ owner: AnyObject, bundle: Bundle = Bundle.main) -> A {
        
        let nibName = NSStringFromClass(classForCoder()).components(separatedBy: ".").last!
        
        let nib = bundle.loadNibNamed(nibName, owner: owner, options: nil)!
        
        for item in nib {
            if let item = item as? A {
                return item
            }
        }
        
        return nib.last as! A
        
    }
    
    func addTransitionFade(_ duration: TimeInterval = 0.5) {
        let animation = CATransition()
        
        animation.type = CATransitionType.fade
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.duration = duration
        
        layer.add(animation, forKey: "kCATransitionFade")
        
    }
    
    func addDashedBorder(borderColour: UIColor, cornerRadius: CGFloat = 5) {
        let color = borderColour.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addSolidBorder(borderColour: UIColor, cornerRadius: CGFloat = 5, width: CGFloat = 2) {
        let color = borderColour.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        shapeLayer.name = "borderLayer"
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func removeBorder() {
        for layer in self.layer.sublayers! {
            if layer.name == "borderLayer" {
                layer.removeFromSuperlayer()
            }
        }
    }
}
