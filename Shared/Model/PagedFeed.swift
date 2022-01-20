//
//  PagedFeed.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 25/7/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

class PagedFeed {
    let totalContentCount: UInt
    let currentOffset: UInt
    let newContentCount: UInt
    let components: [Component]
    
    internal init(totalContentCount: UInt, currentOffset: UInt, newContentCount: UInt, components: [Component]) {
        self.totalContentCount = totalContentCount
        self.currentOffset = currentOffset
        self.newContentCount = newContentCount
        self.components = components
    }
}
