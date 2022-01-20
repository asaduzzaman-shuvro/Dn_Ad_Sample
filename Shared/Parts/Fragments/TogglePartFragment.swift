//
//  TogglePartFragment.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 20/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class TogglePartFragment: PartFragment {
    struct ToggleControlState {
        let text: String
        let contentColor: UIColor
        let backgroundColor: UIColor
    }
    
    var isEnabled: Bool
    let textAttributes: [NSAttributedString.Key: Any]
    let selectedState: ToggleControlState
    let unselectedState: ToggleControlState
    
    init(isEnabled: Bool, textAttributes: [NSAttributedString.Key : Any], selectedState: ToggleControlState, unselectedState: ToggleControlState, size: CGSize, margins: Margins, backgroundColor: UIColor) {
        self.isEnabled = isEnabled
        self.textAttributes = textAttributes
        self.selectedState = selectedState
        self.unselectedState = unselectedState
        
        super.init()
        
        self.size = size
        self.margins = margins
        self.backgroundColor = backgroundColor
    }
}
