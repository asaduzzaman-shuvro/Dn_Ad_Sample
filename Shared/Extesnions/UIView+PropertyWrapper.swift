//
//  AutoLayout+PropertyWrapper.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 7/1/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

@propertyWrapper
struct AutoLayoutView<T: UIView> {
    var constraints : [NSLayoutConstraint]
    
    var wrappedValue: T? {
        didSet{
            wrappedValue?.translatesAutoresizingMaskIntoConstraints = false
            self.constraints = [NSLayoutConstraint]()
        }
    }
    
    var projectedValue: AutoLayoutView<T> {
        return self
    }
    
    init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
        self.wrappedValue?.translatesAutoresizingMaskIntoConstraints = false
        
        self.constraints = [NSLayoutConstraint]()
    }
}
