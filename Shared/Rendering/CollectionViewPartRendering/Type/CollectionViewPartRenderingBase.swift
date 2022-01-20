//
//  CollectionViewPartRenderingBase.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewPartRenderingBase: CollectionViewPartRendering {
    associatedtype Part: CollectionViewPart
    
    var part: Part { get }
    var renderingIndexPath: IndexPath { get }
    
    func doInitialization(_ cell: UICollectionViewCell)
    func doRendering(_ cell: UICollectionViewCell)
    
    func doInitialization(_ reusableView: UICollectionReusableView)
    func doRendering(_ reusableView: UICollectionReusableView)    
}

extension CollectionViewPartRenderingBase {
    var cellNibName: String {
        return part.cellNibName
    }
    
    var cellClass: AnyClass {
        return part.cellClass
    }
    
    var cellReuseId: String {
        return part.cellReuseId
    }
    
    func updatePart() {
        if self.part.representingIndexPath != self.renderingIndexPath {
            self.part.representingIndexPath = self.renderingIndexPath
        }
    }
    
    func render(_ collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = makeCell(collectionView)
        self.updatePart()
        doInitialization(cell)
        doRendering(cell)
        
        return cell
    }
    
    func makeCell(_ collectionView: UICollectionView) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: renderingIndexPath)
    }
    
    func renderReusableView(_ collectionView: UICollectionView) -> UICollectionReusableView {
        let reusableView = makeReUsableHeaderView(collectionView)
        self.updatePart()
        doInitialization(reusableView)
        doRendering(reusableView)
        return reusableView
    }
    
    private func makeReUsableHeaderView(_ collectionView: UICollectionView) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellReuseId, for: renderingIndexPath)
    }
}
