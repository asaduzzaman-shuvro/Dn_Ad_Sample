//
//  CollectionViewSectionSeparatorView.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewSectionSeparatorView: UICollectionReusableView {
    fileprivate var separatorStyle: CollectionViewDecoratorStyle = .none
    fileprivate var separatorColor: UIColor = .clear
    fileprivate var separatorWidth: CGFloat = .zero
    
    fileprivate var addedLayer: [CALayer] = [CALayer] ()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.addedLayer.forEach {
            $0.removeFromSuperlayer()
        }
        
        self.addedLayer.removeAll()
        
        if self.separatorStyle == .around || self.separatorStyle == .topBottom {
            let topBorder = self.getBorder(edge: .top, borderColor: self.separatorColor, borderWidth: self.separatorWidth)
            let bottomBorder = self.getBorder(edge: .bottom, borderColor: self.separatorColor, borderWidth: self.separatorWidth)
            
            self.addedLayer.append(topBorder)
            self.addedLayer.append(bottomBorder)
        }
        
        if self.separatorStyle == .around || self.separatorStyle == .leftRight {
            let leftBorder = self.getBorder(edge: .left, borderColor: self.separatorColor, borderWidth: self.separatorWidth)
            let rightBorder = self.getBorder(edge: .right, borderColor: self.separatorColor, borderWidth: self.separatorWidth)
            
            self.addedLayer.append(leftBorder)
            self.addedLayer.append(rightBorder)
        }
        
        self.addedLayer.forEach {
            self.layer.addSublayer($0)
        }
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attributes = layoutAttributes as? CollectionViewSectionSeparatorLayoutAttributes else {
            return
        }
        
        self.separatorStyle = attributes.separatorStyle
        self.separatorColor = attributes.separatorColor
        self.separatorWidth = attributes.separatorWidth
    }
    
    func getBorder(edge: UIRectEdge, borderColor: UIColor, borderWidth: CGFloat) -> CALayer {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.height)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - borderWidth, width: self.frame.width, height: borderWidth)
        case .right:
            border.frame = CGRect(x: self.frame.width - borderWidth, y: 0, width: borderWidth, height: self.frame.height)
        default:
            break
        }
        
        return border
    }
}
