//
//  PartFragment.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class PartFragment: VaryingSizePart {
    var margins: Margins = Margins()
    var backgroundColor: UIColor = .clear
    
    func isEmpty() -> Bool {
        if self.size.width == .zero || self.size.height == .zero {
            return true
        }
        
        return false
    }
}
