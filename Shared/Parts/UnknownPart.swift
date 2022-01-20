//
//  UnknownPart.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 22/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

class UnknownPart: CollectionViewFeedPart {
    let component: Component
    
    init(component: Component) {
        self.component = component
        
        super.init()
    }
}
