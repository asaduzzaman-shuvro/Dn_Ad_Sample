//
//  CollectionViewBadgeContentTheme.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 4/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewBadgeContentTheme: CollectionViewContentTheme {
    let backgroundColor: UIColor
    let imageTheme: CollectionViewImageContentTheme
    let textTheme: CollectionViewTextContentTheme
    
    init(margins: Margins, backgroundColor: UIColor, imageTheme: CollectionViewImageContentTheme, textTheme: CollectionViewTextContentTheme) {
        self.backgroundColor = backgroundColor
        self.imageTheme = imageTheme
        self.textTheme = textTheme
        
        super.init()
        
        self.margins = margins
    }
}
