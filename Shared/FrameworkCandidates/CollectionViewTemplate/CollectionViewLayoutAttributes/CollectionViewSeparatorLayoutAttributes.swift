//
//  CollectionViewSeparatorLayoutAttributes.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewSeparatorLayoutAttributes: UICollectionViewLayoutAttributes {
    var separatorColor: UIColor = .clear
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let objCopy = super.copy(with: zone) as! CollectionViewSeparatorLayoutAttributes
        objCopy.separatorColor = separatorColor
        return objCopy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? CollectionViewSeparatorLayoutAttributes else {
            return false
        }
        
        if object.separatorColor == self.separatorColor {
            return super.isEqual(object)
        }
        
        return false
    }
}
