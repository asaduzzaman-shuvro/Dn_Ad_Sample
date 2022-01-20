//
//  GeneralCollectionViewPartRenderer.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class GeneralCollectionViewPartRenderer: CollectionViewPartRenderingBase {
    typealias Part = CollectionViewFeedPart
    
    let part: CollectionViewFeedPart
    let renderingIndexPath: IndexPath

    
    init(part: CollectionViewFeedPart, indexPath: IndexPath) {
        self.part = part
        self.renderingIndexPath = indexPath
    }
    
    func doInitialization(_ cell: UICollectionViewCell) {
        if let partDisplayingCell = cell as? CollectionViewPartDisplaying {
            partDisplayingCell.initializeView(with: self.part)
        }
    }
    
    func doRendering(_ cell: UICollectionViewCell) {
        if let partDisplayingCell = cell as? CollectionViewPartDisplaying {
            partDisplayingCell.displayPart(self.part)
        }
    }
    
    func doInitialization(_ reusableView: UICollectionReusableView) {
        if let reusableView = reusableView as? CollectionViewPartDisplaying {
            reusableView.initializeView(with: self.part)
        }
        
    }
    
    func doRendering(_ reusableView: UICollectionReusableView) {
        if let reusableView = reusableView as? CollectionViewPartDisplaying {
            reusableView.displayPart(self.part)
        }
    }
}
