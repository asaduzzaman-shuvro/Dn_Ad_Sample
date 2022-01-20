//
//  IntermediaryPart.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

class IntermediaryPart<SectionType> {
    let section: SectionType
    let components: [Component]
    
    init(section: SectionType, components: [Component]) {
        self.section = section
        self.components = components
    }
}
