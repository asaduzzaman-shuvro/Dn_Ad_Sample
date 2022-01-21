//
//  BadgePartFragment.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 3/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class BadgePartFragment: PartFragment {
    
    let badgeImage: ImagePartFragment?
    let badgeText: AttributedTextPartFragment?
    
    init(badgeImage: ImagePartFragment?, badgeText: AttributedTextPartFragment?, margins: Margins, backgroundColor: UIColor, size: CGSize) {
        self.badgeImage = badgeImage
        self.badgeText = badgeText
        
        super.init()
        
        self.margins = margins
        self.backgroundColor = backgroundColor
        self.size = size
    }
}
