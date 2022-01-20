//
//  CollectionViewSectionLayoutInitialsType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewSectionLayoutInitialsType {
    var supplementaryViewInitialsDefiner: CollectionViewSupplementaryViewInitialsDefinerType { get }
    var sectionDecorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType { get }
    var itemDecorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType { get }
    var cellLayoutInitialsDefiner: CollectionViewCellLayoutInitialsDefinerType { get }
    var sectionInset: UIEdgeInsets { get }
    var isSameHeightCell: Bool {get}
    var contentHeights: [CGFloat] {get set}
    var itemCount: Int {get}
    var rowCount: Int {get}
}

protocol CollectionViewSectionLayoutInitialsDefinerType {
    func prepare(with bounds: CGSize, for scrollDirection: UICollectionView.ScrollDirection)
    func finalise(contentHeights: [CGFloat], headerSize: CGSize, footerSize: CGSize)
    func finalise(contentHeights: [CGFloat])
    
    func adjustHeightForDynamicContent(at index: Int, height: CGFloat)
    func update(contentHeights: [CGFloat])
    func contentReloaded(at index: Int, contentHeight: CGFloat)
    func contentAdded(at index: Int, contentHeight: CGFloat)
    func contentsAdded(at index: Int, contentHeights: [CGFloat])
    func contentRemoved(at index: Int)
    
    func getNecessaryWidthForLayout() -> CGFloat
    func getNecessaryHeightForLayout() -> CGFloat
    func hasSameHeightCell() -> Bool
    
    func getSupplementaryViewHeaderSize() -> CGSize
    func getSupplementaryViewFooterSize() -> CGSize
    func getSupplimentaryViewProvidder() -> CollectionViewSupplementaryViewInitialsDefinerType
    
    func getSectionDecorationInfoProvider() -> CollectionViewDecoratorViewInitialsDefinerType
    func getItemDecorationInfoProvider() -> CollectionViewDecoratorViewInitialsDefinerType
    
    func getMinimumInterItemSpacing() -> CGFloat
    func getLineSpacing() -> CGFloat
    func getItemWidth() -> CGFloat
    func getNoOfItemsInRow() -> Int
    
    func getSectionInset() -> UIEdgeInsets
    func getContentSize(at index: Int) -> CGSize
    func setContentHeights(_ heights: [CGFloat])
    func getContentHeights() -> [CGFloat]
    func getItemCount() -> Int
    func getRowCount() -> Int
}

