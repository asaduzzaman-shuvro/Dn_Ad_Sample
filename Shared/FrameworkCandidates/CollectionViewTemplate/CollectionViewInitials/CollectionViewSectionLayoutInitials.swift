//
//  CollectionViewSectionLayoutInitials.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewSectionLayoutInitials: CollectionViewSectionLayoutInitialsType{
    let supplementaryViewInitialsDefiner: CollectionViewSupplementaryViewInitialsDefinerType
    let sectionDecorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType
    let itemDecorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType
    let cellLayoutInitialsDefiner: CollectionViewCellLayoutInitialsDefinerType
    let sectionInset: UIEdgeInsets
    var contentHeights: [CGFloat]
    let isSameHeightCell: Bool
    
    var itemCount: Int {
        return contentHeights.count
    }
    
    var rowCount: Int {
        let itemsCountInIncompleteRow = self.itemCount % self.getNoOfItemsInRow()
        var rowCount = Int(self.itemCount / self.getNoOfItemsInRow())
        rowCount +=  itemsCountInIncompleteRow > 0 ? 1 : 0
        
        return rowCount
        
        
    }
    
    fileprivate var actualSectionInset: UIEdgeInsets
    fileprivate var necessaryWidthForLayout: CGFloat
    fileprivate var necessaryHeightForLayout: CGFloat
    fileprivate var constrainedDirection: UICollectionView.ScrollDirection
    fileprivate var flexibleDirection: UICollectionView.ScrollDirection
    
    private init(supplementaryViewInitialsDefiner: CollectionViewSupplementaryViewInitialsDefinerType,
         sectionDecorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType,
         itemDecorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType,
         cellLayoutInitialsDefiner: CollectionViewCellLayoutInitialsDefinerType,
         sectionInset: UIEdgeInsets,
         contentHeights: [CGFloat],
         symmetricCellHeight: Bool) {
        self.supplementaryViewInitialsDefiner = supplementaryViewInitialsDefiner
        self.sectionDecorationInitialsDefiner = sectionDecorationInitialsDefiner
        self.itemDecorationInitialsDefiner = itemDecorationInitialsDefiner
        self.cellLayoutInitialsDefiner = cellLayoutInitialsDefiner
        self.sectionInset = sectionInset
        self.contentHeights = contentHeights
        self.isSameHeightCell = symmetricCellHeight
        
        self.actualSectionInset = sectionInset
        self.necessaryWidthForLayout = 0
        self.necessaryHeightForLayout = 0
        self.constrainedDirection = .horizontal
        self.flexibleDirection = .vertical
        
    }
    
    class CVSectionLayoutInitialsBuilder: Builder {
        typealias T = CollectionViewSectionLayoutInitials
        
        var supplmentaryViewInitialsDefiner: CollectionViewSupplementaryViewInitialsDefinerType = CollectionViewSupplementaryViewInitials()
        var sectionDecorationViewInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType = CollectionViewDecoratorViewInitials()
        var itemDecorationViewInitialDefinerType: CollectionViewDecoratorViewInitialsDefinerType = CollectionViewDecoratorViewInitials()
        var cellLayoutInitialsDefiner: CollectionViewCellLayoutInitialsDefinerType = CollectionViewCellLayoutInitials.CVCellLayoutInitialsBuilder().build()
        var sectionInset: UIEdgeInsets = .zero
        var contentHeights: [CGFloat] = []
        var isSameHeightCell: Bool = true
        
        @discardableResult
        func setSupplementaryViewInitialsDefiner(_ definer: CollectionViewSupplementaryViewInitialsDefinerType) -> CVSectionLayoutInitialsBuilder {
            self.supplmentaryViewInitialsDefiner = definer
            return self
        }
        
        @discardableResult
        func setSectionDecorationViewInitialsDefiner(_ definer: CollectionViewDecoratorViewInitialsDefinerType) -> CVSectionLayoutInitialsBuilder {
            self.sectionDecorationViewInitialsDefiner = definer
            return self
        }
        
        @discardableResult
        func setItemDecorationViewInitialsDefiner(_ definer: CollectionViewDecoratorViewInitialsDefinerType) -> CVSectionLayoutInitialsBuilder {
            self.itemDecorationViewInitialDefinerType = definer
            return self
        }
        
        @discardableResult
        func setCellLayoutInitialsDefiner(_ definer: CollectionViewCellLayoutInitialsDefinerType) -> CVSectionLayoutInitialsBuilder {
            self.cellLayoutInitialsDefiner = definer
            return self
        }
        
        @discardableResult
        func setSectionInset(_ inset: UIEdgeInsets) -> CVSectionLayoutInitialsBuilder {
            self.sectionInset = inset
            return self
        }
        
        @discardableResult
        func setContentHeights(_ heights: [CGFloat]) -> CVSectionLayoutInitialsBuilder {
            self.contentHeights = heights
            return self
        }
        
        @discardableResult
        func setIsSameHeightCell(_ flag: Bool) -> CVSectionLayoutInitialsBuilder {
            self.isSameHeightCell = flag
            return self
        }
        
        func build() -> CollectionViewSectionLayoutInitials {
            return CollectionViewSectionLayoutInitials(supplementaryViewInitialsDefiner: self.supplmentaryViewInitialsDefiner,
                                           sectionDecorationInitialsDefiner: self.sectionDecorationViewInitialsDefiner,
                                           itemDecorationInitialsDefiner: self.itemDecorationViewInitialDefinerType,
                                           cellLayoutInitialsDefiner: self.cellLayoutInitialsDefiner,
                                           sectionInset: self.sectionInset,
                                           contentHeights: self.contentHeights,
                                           symmetricCellHeight: self.isSameHeightCell)
        }
    }
    
}

extension CollectionViewSectionLayoutInitials {
    fileprivate func calculateActualSectionInset(withPadding padding: CGFloat = .zero) {
        let actualTopInset = self.sectionInset.top + self.sectionDecorationInitialsDefiner.occupiedSpaceInTop() + self.itemDecorationInitialsDefiner.occupiedSpaceInTop()
        let actualLeftInset = self.sectionInset.left + self.sectionDecorationInitialsDefiner.occupiedSpaceInLeft() + self.itemDecorationInitialsDefiner.occupiedSpaceInLeft() + padding
        let actualBottomInset = self.sectionInset.bottom + self.sectionDecorationInitialsDefiner.occupiedSpaceInBottom() + self.itemDecorationInitialsDefiner.occupiedSpaceInBottom()
        let actualRightInset = self.sectionInset.right + self.sectionDecorationInitialsDefiner.occupiedSpaceInRight() + self.itemDecorationInitialsDefiner.occupiedSpaceInRight() + padding
        
        self.actualSectionInset = UIEdgeInsets(top: actualTopInset, left: actualLeftInset, bottom: actualBottomInset, right: actualRightInset)
    }
    
    fileprivate func finaliseWidthForVerticalScrollingDirection() {
        necessaryWidthForLayout = CGFloat(self.getNoOfItemsInRow()) * self.getItemWidth()
        
        let noOfTimesItemSpacingNeedToAppear = self.getNoOfItemsInRow() - 1
        
        necessaryWidthForLayout += CGFloat(noOfTimesItemSpacingNeedToAppear) * self.getMinimumInterItemSpacing()
        necessaryWidthForLayout += self.actualSectionInset.left + self.actualSectionInset.right
    }
    
    fileprivate func finaliseWidthForHorizontalScrollingDirection() {
        let rowCount = self.rowCount
        necessaryWidthForLayout = CGFloat(rowCount) * self.getItemWidth()
        
        necessaryWidthForLayout += CGFloat(rowCount - 1) * self.getLineSpacing()
        necessaryWidthForLayout += self.actualSectionInset.left + self.actualSectionInset.right
    }
    
    fileprivate func finaliseHeightForVerticalScrollingDirection() {
        let rowCount = self.getRowCount()
        
        guard rowCount > 0 else {
            return
        }
        
        // Add header height(if any), section inset top & bottom, section decoration space(if any), footer height(if any)
        var height = self.getSupplementaryViewHeaderSize().height + self.actualSectionInset.top
            + self.actualSectionInset.bottom + self.getSupplementaryViewFooterSize().height
        
        // Add line spacing
        height += CGFloat(rowCount - 1) * self.getLineSpacing()
        
        // Add item heights
        if self.isSameHeightCell {
            height += self.contentHeights[self.contentHeights.startIndex] * CGFloat(rowCount)
        }else {
            var index = self.contentHeights.startIndex
            
            for _ in 0..<rowCount {
                // Height of first element in the row
                var maxItemHeight = self.contentHeights[index]
                
                // For non symmetrical item get the hightest height in the row
                for offset in 1..<self.getNoOfItemsInRow() {
                    let currentIndex = index + offset
                    
                    if self.contentHeights.indices.contains(currentIndex) {
                        let contentHeight = self.contentHeights[currentIndex]
                        if  contentHeight > maxItemHeight {
                            maxItemHeight = contentHeight
                        }
                    }
                }
                
                height += maxItemHeight
                
                index += self.getNoOfItemsInRow()
            }
        }
        
        self.necessaryHeightForLayout = height
    }
    
    fileprivate func finaliseHeightForHorizontalScrollingDirection() {
        let rowCount = self.getRowCount()
        
        guard rowCount > 0 else {
            return
        }
        
        // Add section inset top & bottom, section decoration space(if any)
        var height = self.actualSectionInset.top + self.actualSectionInset.bottom
        
        // Add inter item spacing, as we are considering horizontal scrolling direction
        let noOfTimesItemSpacingNeedToAppear = self.getNoOfItemsInRow() - 1
        height += self.getMinimumInterItemSpacing() * CGFloat(noOfTimesItemSpacingNeedToAppear)
        
        // Add item heights
        if self.isSameHeightCell {
            height += self.contentHeights[self.contentHeights.startIndex] * CGFloat(self.getNoOfItemsInRow())
        }else {
            var index = self.contentHeights.startIndex
            var maxRowHeight: CGFloat = CGFloat.zero
            
            for _ in 0..<rowCount {
                var rowHeight: CGFloat = CGFloat.zero
                for offset in 0..<self.getNoOfItemsInRow() {
                    let currentIndex = index + offset
                    
                    if self.contentHeights.indices.contains(currentIndex) {
                        rowHeight += self.contentHeights[currentIndex]
                    }
                }
                
                if rowHeight > maxRowHeight {
                    maxRowHeight = rowHeight
                }
                
                index += self.getNoOfItemsInRow()
            }
            
            height += maxRowHeight
        }
        
        self.necessaryHeightForLayout = height
    }
}


extension CollectionViewSectionLayoutInitials: CollectionViewSectionLayoutInitialsDefinerType {
   
    
    func prepare(with bounds: CGSize, for scrollDirection: UICollectionView.ScrollDirection) {
        self.calculateActualSectionInset()
        
        var actualBounds = bounds
        
        if scrollDirection == .vertical {
            actualBounds.width = bounds.width - self.actualSectionInset.left - self.actualSectionInset.right
        }else {
            self.constrainedDirection = .vertical
            self.flexibleDirection = .horizontal
        }
        
        self.cellLayoutInitialsDefiner.prepare(for: scrollDirection,
                                               bounds: actualBounds,
                                               decorationInitialsDefiner: self.itemDecorationInitialsDefiner)
        
        let unadjustableSpace = self.cellLayoutInitialsDefiner.getUnadjustableSpaceAfterInitialsAdjustment()
        if unadjustableSpace > .zero {
            self.calculateActualSectionInset(withPadding: (unadjustableSpace / 2).rounded(.down))
        }
    }
    
    func finalise(contentHeights: [CGFloat], headerSize: CGSize, footerSize: CGSize) {
        self.supplementaryViewInitialsDefiner.setHeaderSize(headerSize)
        self.supplementaryViewInitialsDefiner.setFooterSize(footerSize)
        
        self.finalise(contentHeights: contentHeights)
    }
    
    func finalise(contentHeights: [CGFloat]) {
        self.contentHeights = contentHeights
        
        self.performAdditionalInitialsCalculation()
    }
    
    fileprivate func performAdditionalInitialsCalculation() {
        if self.flexibleDirection == .vertical {
            self.finaliseWidthForVerticalScrollingDirection()
            self.finaliseHeightForVerticalScrollingDirection()
        }else {
            self.finaliseWidthForHorizontalScrollingDirection()
            self.finaliseHeightForHorizontalScrollingDirection()
        }
    }
    
    func adjustHeightForDynamicContent(at index: Int, height: CGFloat) {
        self.contentHeights[index] = height
        
        self.performAdditionalInitialsCalculation()
    }
    
    func update(contentHeights: [CGFloat]) {
        self.contentHeights = contentHeights
        self.performAdditionalInitialsCalculation()
    }
    
    func contentReloaded(at index: Int, contentHeight: CGFloat) {
        if self.isSameHeightCell {
            return
        }
        
        self.contentHeights[index] = contentHeight
        self.performAdditionalInitialsCalculation()
    }
    
    func contentAdded(at index: Int, contentHeight: CGFloat) {
        self.contentHeights.insert(contentHeight, at: index)
        self.performAdditionalInitialsCalculation()
    }
    
    func contentsAdded(at index: Int, contentHeights: [CGFloat]) {
        self.contentHeights.insert(contentsOf: contentHeights, at: index)
        self.performAdditionalInitialsCalculation()
    }
    
    func contentRemoved(at index: Int) {
        self.contentHeights.remove(at: index)
        self.performAdditionalInitialsCalculation()
    }
    
    func getNecessaryWidthForLayout() -> CGFloat {
        return self.necessaryWidthForLayout
    }
        
    func getNecessaryHeightForLayout() -> CGFloat {
        return self.necessaryHeightForLayout
    }
    
    func hasSameHeightCell() -> Bool {
        return self.isSameHeightCell
    }

    func getSupplementaryViewHeaderSize() -> CGSize {
        return self.supplementaryViewInitialsDefiner.getHeaderSize()
    }
    
    func getSupplementaryViewFooterSize() -> CGSize {
        return self.supplementaryViewInitialsDefiner.getFooterSize()
    }
    
    func getSupplimentaryViewProvidder() -> CollectionViewSupplementaryViewInitialsDefinerType {
        self.supplementaryViewInitialsDefiner
    }
    
    func getSectionDecorationInfoProvider() -> CollectionViewDecoratorViewInitialsDefinerType {
        return self.sectionDecorationInitialsDefiner
    }
    
    func getItemDecorationInfoProvider() -> CollectionViewDecoratorViewInitialsDefinerType {
        return self.itemDecorationInitialsDefiner
    }
    
    func getMinimumInterItemSpacing() -> CGFloat {
        return self.cellLayoutInitialsDefiner.getInterItemSpacing()
    }
    
    func getLineSpacing() -> CGFloat {
        return self.cellLayoutInitialsDefiner.getLineSpacing()
    }
    
    func getItemWidth() -> CGFloat {
        return self.cellLayoutInitialsDefiner.getItemWidth()
    }
    
    func getNoOfItemsInRow() -> Int {
        return self.cellLayoutInitialsDefiner.getNoOfItemsInRow()
    }
        
    func getSectionInset() -> UIEdgeInsets {
        return self.actualSectionInset
    }
    
    func getContentSize(at index: Int) -> CGSize {
        guard contentHeights.indices.contains(index) else {
            return .zero
        }
        
        return CGSize(width: self.getItemWidth(), height: contentHeights[index])
    }
    
    func setContentHeights(_ heights: [CGFloat]) {
        self.contentHeights = heights
    }
    
    func getContentHeights() -> [CGFloat] {
        return self.contentHeights
    }

    func getItemCount() -> Int {
        return self.itemCount
    }
    
    func getRowCount() -> Int {
        return self.rowCount
    }
}

