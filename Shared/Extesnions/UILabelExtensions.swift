//
//  UILabelExtensions.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 6/10/21.
//  Copyright © 2021 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    /// Displays the attributed string with the updated line break mode.
    ///
    /// - Parameters:
    ///   - attrString: The attributed string to display.
    ///   - lineBreakMode: The line break mode to update to.
    func display(attrString: NSAttributedString?, updatingLineBreakModeWith lineBreakMode: NSLineBreakMode) {
        self.attributedText = attrString
        self.lineBreakMode = lineBreakMode
    }
}
