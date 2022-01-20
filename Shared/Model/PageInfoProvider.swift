//
//  PageInfoProvider.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 25/7/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

struct PageInfo {
    var currentPage: UInt = 0
    var totalItems: UInt = 0
    var size: UInt = 0
    var offset: UInt = 0
    
    init() {
        self.currentPage = 0
        self.totalItems = 0
        self.size = 0
        self.offset = 0
    }
    
    init(withCurrentPage currentPage: UInt, totalItems: UInt, size: UInt, offset: UInt) {
        self.currentPage = currentPage
        self.totalItems = totalItems
        self.size = size
        self.offset = offset
    }
}

extension PageInfo {
    var loadNext: Bool {
        guard totalItems != 0, (offset + size) < totalItems else {
            return false
        }
        return true
    }
    
    mutating func reset() {
        self.currentPage = 0
        self.totalItems = 0
        self.size = 0
        self.offset = 0
    }
    
    var isFirstPage: Bool {
        return currentPage == 0
    }
    
}
