//
//  CollectionViewSupplementaryViewInitials.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewSupplementaryViewInitials: CollectionViewSupplementaryViewInitialsType {
    var headerReferenceSize: CGSize
    var footerReferenceSize: CGSize
    var headerPart: CollectionViewFeedPart?
    
    
    convenience init() {
        self.init(headerReferenceSize: .zero, footerReferenceSize: .zero)
    }
    
    init(headerReferenceSize: CGSize, footerReferenceSize: CGSize, headerPart: CollectionViewPart? = nil) {
        self.headerReferenceSize = headerReferenceSize
        self.footerReferenceSize = footerReferenceSize
        self.headerPart = nil
    }
}

extension CollectionViewSupplementaryViewInitials: CollectionViewSupplementaryViewInitialsDefinerType {
    func getHeaderSize() -> CGSize {
        return self.headerReferenceSize
    }
    
    func setHeaderSize(_ size: CGSize) {
        self.headerReferenceSize = size
    }
    
    func getFooterSize() -> CGSize {
        return footerReferenceSize
    }
    
    func setFooterSize(_ size: CGSize) {
        self.footerReferenceSize = size
    }
    
    func getHeaderPart() -> CollectionViewFeedPart? {
        return self.headerPart
    }
    
    func setHeaderPart(_ header: CollectionViewFeedPart?) {
        self.headerPart = header
    }
}

