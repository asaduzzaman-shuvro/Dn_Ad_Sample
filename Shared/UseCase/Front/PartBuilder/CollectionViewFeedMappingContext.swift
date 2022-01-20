//
//  CollectionViewFeedMappingContext.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewFeedMappingContext: FeedMappingContextType {
    
    fileprivate (set) var previousPart: CollectionViewPortion
    fileprivate (set) var backgroundColor: UIColor
    fileprivate (set) var contentWidth: CGFloat
    fileprivate (set) var disableTopRounding: Bool
    fileprivate (set) var disableBottomRounding: Bool

    convenience init(contentWidth: CGFloat) {
        self.init(contentWidth: contentWidth, disableTopRounding: true, disableBottomRounding: true)
    }
    
    convenience init(contentWidth: CGFloat, disableTopRounding: Bool, disableBottomRounding: Bool) {
        self.init(previousPart: .top, backgroundColor: .clear, contentWidth: contentWidth, disableTopRounding: disableTopRounding, disableBottomRounding: disableBottomRounding)
    }
    
    init(previousPart: CollectionViewPortion, backgroundColor: UIColor, contentWidth: CGFloat, disableTopRounding: Bool, disableBottomRounding: Bool) {
        self.previousPart = previousPart
        self.backgroundColor = backgroundColor
        self.contentWidth = contentWidth
        self.disableTopRounding = disableTopRounding
        self.disableBottomRounding = disableBottomRounding
    }
    
    func changePreviousPart(_ part: CollectionViewPortion) {
        self.previousPart = part
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func changeContentWidth(width: CGFloat) {
        self.contentWidth = width
    }
    
    func configureTopRounding(enable: Bool) {
        self.disableTopRounding = !enable
    }
    
    func configureBottomRounding(enable: Bool) {
        self.disableBottomRounding = !enable
    }
}
