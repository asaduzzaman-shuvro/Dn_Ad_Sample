//
//  CollectionViewControlStateTheme.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 19/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

/// Theme for Control State(i.e. UIControl).
class CollectionViewControlStateTheme {

    /// Content color for the control state.
    let contentColor: UIColor
    
    /// Background color of text content theme.
    let backgroundColor: UIColor
    
    /// Control state theme with no background color.
    /// - Parameter contentColor: Content color for the control state
    convenience init(contentColor: UIColor) {
        self.init(contentColor: contentColor, backgroundColor: .clear)
    }
    
    /// Designated initializer for ControlStateTheme.
    /// - Parameters:
    ///   - contentColor: Content color for the control state
    ///   - backgroundColor: Background color for the control state
    init(contentColor: UIColor, backgroundColor: UIColor) {
        self.contentColor = contentColor
        self.backgroundColor = backgroundColor
    }
}
