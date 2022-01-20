//
//  CollectionViewImageContentTheme.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

/// Theme class for image content
class CollectionViewImageContentTheme: CollectionViewContentTheme {
    
    /// Image tint color, nil means no tint color is to be applied.
    let imageTintColor: UIColor?
    
    /// Background color of image content.
    let backgroundColor: UIColor
    
    /// Image content theme with zero margins, no tint color and clear background color.
    override init() {
        self.imageTintColor = nil
        self.backgroundColor = .clear
        
        super.init()
    }
    
    /// Image content theme with no image tint color and clear background color.
    /// - Parameters:
    ///   - margins: Image margin
    convenience init(margins: Margins) {
        self.init(margins: margins, imageTintColor: nil, backgroundColor: .clear)
    }
    
    /// Image content theme with no margins and clear background color.
    /// - Parameters:
    ///   - imageTintColor: Image tint color
    convenience init(imageTintColor: UIColor) {
        self.init(margins: Margins(), imageTintColor: imageTintColor, backgroundColor: .clear)
    }
    
    /// Image content theme with clear background color.
    /// - Parameters:
    ///   - margins: Image margins
    ///   - imageTintColor: Image tint color
    convenience init(margins: Margins, imageTintColor: UIColor) {
        self.init(margins: margins, imageTintColor: imageTintColor, backgroundColor: .clear)
    }
    
    /// Designated initializer for image content theme.
    /// - Parameters:
    ///   - margins: Image margins
    ///   - imageTintColor: Image tint color
    ///   - backgroundColor: Image background color
    init(margins: Margins, imageTintColor: UIColor?, backgroundColor: UIColor) {
        self.imageTintColor = imageTintColor
        self.backgroundColor = backgroundColor
        
        super.init()
        
        self.margins = margins
    }
}
