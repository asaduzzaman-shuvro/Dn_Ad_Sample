//
//  CollectionViewItemSeparatorView.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewItemSeparatorView: UICollectionReusableView {
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame

        guard let attributes = layoutAttributes as? CollectionViewSeparatorLayoutAttributes else{
            return
        }
        
        self.backgroundColor = attributes.separatorColor
    }
}
