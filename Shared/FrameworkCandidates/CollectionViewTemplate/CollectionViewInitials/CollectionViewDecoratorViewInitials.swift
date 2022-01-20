//
//  CollectionViewDecoratorViewInitials.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewDecoratorViewInitials: CollectionViewDecoratorViewInitialsType {
    let style: CollectionViewDecoratorStyle
    let width: CGFloat
    let color: UIColor
    let padding: CGFloat
    
    convenience init() {
        self.init(style: .none, width: .zero, color: .clear, padding: .zero)
    }
    
    convenience init(style: CollectionViewDecoratorStyle, width: CGFloat, color: UIColor) {
        self.init(style: style, width: width, color: color, padding: .zero)
    }
    
    init(style: CollectionViewDecoratorStyle, width: CGFloat, color: UIColor, padding: CGFloat) {
        self.style = style
        self.width = width < .zero ? .zero : width
        self.color = color
        self.padding = padding > .zero ? padding : .zero
    }
}

extension CollectionViewDecoratorViewInitials: CollectionViewDecoratorViewInitialsDefinerType {
    func decoratorViewStyle() -> CollectionViewDecoratorStyle {
        return self.style
    }
    
    func decoratorViewWidth() -> CGFloat {
        return self.width
    }
    
    func decoratorViewColor() -> UIColor {
        return self.color
    }
    
    func decoratorViewPadding() -> CGFloat {
        return self.padding
    }
}

