//
//  CollectionViewDecoratorViewInitialsType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewDecoratorViewInitialsType {
    var style: CollectionViewDecoratorStyle { get }
    var width: CGFloat { get }
    var color: UIColor { get }
}

protocol CollectionViewDecoratorViewInitialsDefinerType: LayoutInitialsDefinerType {
    func decoratorViewStyle() -> CollectionViewDecoratorStyle
    func decoratorViewWidth() -> CGFloat
    func decoratorViewColor() -> UIColor
    func decoratorViewPadding() -> CGFloat
}

extension CollectionViewDecoratorViewInitialsDefinerType {
    func totalOccupiedSpace() -> CGFloat {
        return occupiedSpaceInHorizontalDirection() + occupiedSpaceInVerticalDirection()
    }
    
    func occupiedSpaceInVerticalDirection() -> CGFloat {
        return occupiedSpaceInTop() + occupiedSpaceInBottom()
    }
    
    func occupiedSpaceInHorizontalDirection() -> CGFloat {
        return occupiedSpaceInLeft() + occupiedSpaceInRight()
    }
    
    func occupiedSpaceInTop() -> CGFloat {
        switch self.decoratorViewStyle() {
        case .around, .topBottom:
            return self.decoratorViewWidth()
        default:
            return 0
        }
    }
    
    func occupiedSpaceInBottom() -> CGFloat {
        switch self.decoratorViewStyle() {
        case .around, .topBottom, .interRow:
            return self.decoratorViewWidth()
        default:
            return 0
        }
    }
    
    func occupiedSpaceInLeft() -> CGFloat {
        switch self.decoratorViewStyle() {
        case .around, .leftRight:
            return self.decoratorViewWidth()
        default:
            return 0
        }
    }
    
    func occupiedSpaceInRight() -> CGFloat {
        switch self.decoratorViewStyle() {
        case .around, .leftRight:
            return self.decoratorViewWidth()
        default:
            return 0
        }
    }
}

