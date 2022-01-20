//
//  AttributedTextPartFragment.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class AttributedTextPartFragment: PartFragment {
    let attributedString: NSAttributedString
    
    init(attributedString: NSAttributedString, size: CGSize, margins: Margins, backgroundColor: UIColor) {
        self.attributedString = attributedString
        
        super.init()
        
        self.size = size
        self.margins = margins
        self.backgroundColor = backgroundColor
    }
    
    override func isEmpty() -> Bool {
        if super.isEmpty() || self.attributedString.string.isEmpty {
            return true
        }
        
        return false
    }
}
