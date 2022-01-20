//
//  CollectionViewSectionSeparatorLayoutAttributes.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewSectionSeparatorLayoutAttributes: CollectionViewSeparatorLayoutAttributes {
    var separatorStyle: CollectionViewDecoratorStyle = .none
    var separatorWidth: CGFloat = .zero
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let objCopy = super.copy(with: zone) as! CollectionViewSectionSeparatorLayoutAttributes
        objCopy.separatorStyle = self.separatorStyle
        objCopy.separatorWidth = self.separatorWidth
        
        return objCopy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? CollectionViewSectionSeparatorLayoutAttributes else {
            return false
        }
        
        if object.separatorWidth == self.separatorWidth && object.separatorStyle == self.separatorStyle {
            return super.isEqual(object)
        }
        
        return false
    }
    
}
