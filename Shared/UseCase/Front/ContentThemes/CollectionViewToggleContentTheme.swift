//
//  CollectionViewToggleContentTheme.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 19/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

/// Toggle control theme.
class CollectionViewToggleContentTheme: CollectionViewContentTheme {
    
    /// Text content theme for toggle.
    let textContentTheme: CollectionViewTextContentTheme
    
    /// Selected state theme for toggle.
    let selectedStateTheme: CollectionViewControlStateTheme
    
    /// Unselected state theme for toggle.
    let unselectedStateTheme: CollectionViewControlStateTheme

    /// Toggle control theme with no margin.
    /// - Parameters:
    ///   - textContentTheme: Text content theme of control
    ///   - selectedStateTheme: Selected state theme of control
    ///   - unselectedStateTheme: Unselected state theme of control
    convenience init(textContentTheme: CollectionViewTextContentTheme, selectedStateTheme: CollectionViewControlStateTheme, unselectedStateTheme: CollectionViewControlStateTheme) {
        self.init(margins: Margins(), textContentTheme: textContentTheme, selectedStateTheme: selectedStateTheme, unselectedStateTheme: unselectedStateTheme)
    }
    
    
    /// Designated initializer for toggle control theme.
    /// - Parameters:
    ///   - margins: Margins of control
    ///   - textContentTheme: Text content theme of control
    ///   - selectedStateTheme: Selected state theme of control
    ///   - unselectedStateTheme: Unselected state theme of control
    init(margins: Margins, textContentTheme: CollectionViewTextContentTheme, selectedStateTheme: CollectionViewControlStateTheme, unselectedStateTheme: CollectionViewControlStateTheme) {
        self.textContentTheme = textContentTheme
        self.selectedStateTheme = selectedStateTheme
        self.unselectedStateTheme = unselectedStateTheme
        
        super.init()
        
        self.margins = margins
    }
}
