//
//  VaryingSizePart.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

/// Base class of any part
class VaryingSizePart {
    
    /// Part size. Default is zero.
    var size: CGSize = .zero
}

extension VaryingSizePart {
    func changeHeight(_ height: CGFloat) {
        self.size = CGSize(width: self.size.width, height: height)
    }
}
