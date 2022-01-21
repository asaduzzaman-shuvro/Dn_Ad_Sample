//
// Created by Apps AS on 11/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        let elements = UINib(nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)
        return elements[0] as? UIView
    }
    
    func takeScreenshot() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(
                 CGSize(width: self.bounds.width, height: self.bounds.height),
                 false,
                 2
             )

             layer.render(in: UIGraphicsGetCurrentContext()!)
             let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
             UIGraphicsEndImageContext()
        return screenshot
//
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
//        drawHierarchy(in: self.bounds, afterScreenUpdates: false)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
    }
    
    func hideView(topMargin: NSLayoutConstraint?,
                  bottomMargin: NSLayoutConstraint?,
                  leadingMargin: NSLayoutConstraint?,
                  trailingMargin: NSLayoutConstraint?,
                  widthConstraint: NSLayoutConstraint?,
                  heightConstraint: NSLayoutConstraint?) {
        if !self.isHidden {
            self.isHidden = true
            topMargin?.constant = .zero
            bottomMargin?.constant = .zero
            leadingMargin?.constant = .zero
            trailingMargin?.constant = .zero
            widthConstraint?.constant = .zero
            heightConstraint?.constant = .zero

        }
    }

}

extension NibInitializable where Self : UIView {
    static func fromNib() -> Self {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as! Self
    }
}

extension UIView: NibInitializable {
    static var nibName: String {
        return "\(self)"
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle.main)
    }
}

//------------------------------------------------------
// MARK:- Nib Initialization Protocol
//------------------------------------------------------

protocol NibInitializable {
    static var nibName: String { get }
}


