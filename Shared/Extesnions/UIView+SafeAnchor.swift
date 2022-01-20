//
//  UIView+SafeAnchor.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }else {
            return self.layoutMarginsGuide.topAnchor
        }
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        }else {
            return self.layoutMarginsGuide.leadingAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }else {
            return self.layoutMarginsGuide.bottomAnchor
        }
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        }else {
            return self.layoutMarginsGuide.trailingAnchor
        }
    }
    
    var safeCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11, *) {
            return self.safeAreaLayoutGuide.centerXAnchor
        }else {
            return self.layoutMarginsGuide.centerXAnchor
        }
    }
    
    var safeCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11, *) {
            return self.safeAreaLayoutGuide.centerYAnchor
        }else {
            return self.layoutMarginsGuide.centerYAnchor
        }
    }
}

