//
// Created by Apps AS on 17/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }

    func clearCornerRounding() {
        guard self.layer.mask != nil else {
            return
        }

        self.layer.mask = nil
        self.layer.masksToBounds = false
    }
    
    func addBorder(borderWidth: CGFloat, withColor color: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
    
    func addCorner(radious: CGFloat) {
        self.layer.cornerRadius = radious
        self.layer.masksToBounds = true
    }
    
   func addShadow(with shadowOffset: CGSize, shadowColor: UIColor = UIColor.gray, radious: CGFloat = 2, opacity: Float = 0.8) {
       self.layer.shadowOffset = shadowOffset
       self.layer.shadowColor = shadowColor.cgColor
       self.layer.shadowRadius = radious
       self.layer.shadowOpacity = opacity
   }
}



//*************************************************
//MARK:- CGRect 
//*************************************************
extension UIView {
    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newValue, height: frame.size.height)
        }
    }
    
    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: newValue)
        }
    }
    
    var coordinate: CGPoint {
        set {
            frame = CGRect(x: newValue.x, y: newValue.y, width: width, height: height)
        }
        get {
            return frame.origin
        }
    }
    
    @IBInspectable
    var cornerRadious: CGFloat {
        set{
            self.addCorner(radious: newValue)
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
}

extension UIButton {
    @IBInspectable
    var kern: CGFloat {
        set {
            if let currentAttibutedText = self.titleLabel?.attributedText {
                let attribString = NSMutableAttributedString(attributedString: currentAttibutedText)
                attribString.addAttributes([NSAttributedString.Key.kern:newValue], range:NSMakeRange(0, currentAttibutedText.length))
                self.setAttributedTitle(attribString, for: state)
            }
        }
        
        get {
            var kerning:CGFloat = 0
            if let attributedText = self.titleLabel?.attributedText {
                attributedText.enumerateAttribute(NSAttributedString.Key.kern,
                                                  in: NSMakeRange(0, attributedText.length),
                                                  options: .init(rawValue: 0)) { (value, range, stop) in
                                                    kerning = value as? CGFloat ?? 0
                }
            }
            return kerning

        }
    }
    
}
