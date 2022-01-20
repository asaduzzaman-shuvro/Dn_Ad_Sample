//
//  DFPAdPart.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 15/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit

class DFPAdPart: CollectionViewFeedPart {
    weak var delegate: AdComponentDelegate?
    
    var adAlias: String
    let isResizable: Bool
    let isRemovable: Bool
    private(set) var loadedAdSize: CGSize
    
    /// Unique identifier of the ad component.
    var adUniqueIdentifier: String {
        return "\(self.uID.uuidString)_\(self.adAlias)"
    }
    
    private init(adAlias: String, isResizable: Bool, isRemovable: Bool, loadedAdSize: CGSize, size: CGSize) {
        self.adAlias = adAlias
        self.isResizable = isResizable
        self.isRemovable = isRemovable
        self.loadedAdSize = loadedAdSize
    
        super.init()
        
        self.size = size
        self.cellNibName = "" //DFPAdCollectionViewCell.nibName
        self.cellReuseId =  ""//DFPAdCollectionViewCell.reusableIdentifier
    }
}

extension DFPAdPart {
    class Builder {
        private var adAlias: String = ""
        private var isResizable: Bool = true
        private var isRemovable: Bool = true
        private var loadedAdSize: CGSize = .zero
        private var size: CGSize = .zero
        
        func set(adAlias: String) -> Builder {
            self.adAlias = adAlias
            return self
        }
        
        func set(isResizable: Bool) -> Builder {
            self.isResizable = isResizable
            return self
        }
        
        func set(isRemovable: Bool) -> Builder {
            self.isRemovable = isRemovable
            return self
        }
        
        func set(loadedAdSize: CGSize) -> Builder {
            self.loadedAdSize = loadedAdSize
            return self
        }
        
        func set(size: CGSize) -> Builder {
            self.size = size
            return self
        }
        
        func build() -> DFPAdPart {
            return DFPAdPart(adAlias: self.adAlias, isResizable: self.isResizable, isRemovable: self.isRemovable, loadedAdSize: self.loadedAdSize, size: self.size)
        }
    }
}

extension DFPAdPart {
    func changeLoadedAdSize(size: CGSize) {
        self.loadedAdSize = size
    }
}
