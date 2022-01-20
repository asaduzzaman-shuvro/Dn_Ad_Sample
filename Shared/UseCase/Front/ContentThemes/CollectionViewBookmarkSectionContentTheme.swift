//
//  CollectionViewBookmarkSectionContentTheme.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 3/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewBookmarkSectionContentTheme: CollectionViewContentTheme {
    let headerTheme: CollectionViewTextContentTheme
    let skinImageTheme: CollectionViewImageContentTheme
    let bookmarkImageTheme: CollectionViewImageContentTheme
    
    init(margins: Margins, headerTheme: CollectionViewTextContentTheme, skinImageTheme: CollectionViewImageContentTheme,
         bookmarkImageTheme: CollectionViewImageContentTheme) {
        self.headerTheme = headerTheme
        self.skinImageTheme = skinImageTheme
        self.bookmarkImageTheme = bookmarkImageTheme
        
        super.init()
        
        self.margins = margins
    }
}
