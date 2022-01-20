//
//  CollectionViewCellLayoutInitials.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCellLayoutInitials: CollectionViewCellLayoutInitialsType {
    let minimumInterItemSpacing: CGFloat
    let lineSpacing: CGFloat
    let expectedItemWidth: CGFloat
    let expectedNoOfItemsInRow: Int
    
    fileprivate var actualInterItemSpacing: CGFloat
    fileprivate var actualLineSpacing: CGFloat
    fileprivate var actualItemWidth: CGFloat
    fileprivate var actualNoOfItemsInRow: Int
    fileprivate var unadjustableSpace: CGFloat
    
    private init(minimumInterItemSpacing: CGFloat, lineSpacing: CGFloat, expectedItemWidth: CGFloat, expectedNoOfItemsInRow: Int) {
        self.minimumInterItemSpacing = minimumInterItemSpacing
        self.lineSpacing = lineSpacing
        self.expectedItemWidth = expectedItemWidth
        self.expectedNoOfItemsInRow = expectedNoOfItemsInRow
        
        self.actualInterItemSpacing = minimumInterItemSpacing
        self.actualLineSpacing = lineSpacing
        self.actualItemWidth = expectedItemWidth
        self.actualNoOfItemsInRow = expectedNoOfItemsInRow
        self.unadjustableSpace = .zero
    }
    
    class CVCellLayoutInitialsBuilder: Builder {
        typealias T = CollectionViewCellLayoutInitials
        
        var minimumInterItemSpacing: CGFloat = 10
        var lineSpacing: CGFloat = 10
        var expectedItemWidth: CGFloat = 50
        var expectedNoOfItemsInRow = 1
        
        func setMinimumInterItemSpacing(_ spacing: CGFloat) -> CVCellLayoutInitialsBuilder {
            self.minimumInterItemSpacing = spacing
            return self
        }
        
        func setLineSpacing(_ spacing: CGFloat) -> CVCellLayoutInitialsBuilder {
            self.lineSpacing = spacing
            return self
        }
        
        func setExpectedItemWidth(_ width: CGFloat) -> CVCellLayoutInitialsBuilder {
            self.expectedItemWidth = width > CGFloat.zero ? width : CGFloat.zero
            return self
        }
        
        func setExpectedNoOfItemsInRow(_ number: Int) -> CVCellLayoutInitialsBuilder {
            self.expectedNoOfItemsInRow = number > 0 ? number : 1
            return self
        }
        
        func build() -> CollectionViewCellLayoutInitials {
            return CollectionViewCellLayoutInitials(minimumInterItemSpacing: self.minimumInterItemSpacing, lineSpacing: self.lineSpacing,
                                        expectedItemWidth: self.expectedItemWidth, expectedNoOfItemsInRow: self.expectedNoOfItemsInRow)
        }
    }
}

extension CollectionViewCellLayoutInitials {
    fileprivate func noOfTimesItemSpacingNeedToAppear() -> Int {
        return self.actualNoOfItemsInRow - 1
    }
    
    func adjustInterItemSpacing(for scrollDirection: UICollectionView.ScrollDirection ,with decorationInitials: CollectionViewDecoratorViewInitialsDefinerType) {
        if scrollDirection == .vertical {
            self.actualInterItemSpacing = self.minimumInterItemSpacing
            + decorationInitials.occupiedSpaceInLeft()
            + decorationInitials.occupiedSpaceInRight()
        }else {
            self.actualInterItemSpacing = self.minimumInterItemSpacing
                + decorationInitials.occupiedSpaceInTop()
                + decorationInitials.occupiedSpaceInBottom()
        }
    }
    
    func adjustLineSpacing(for scrollDirection: UICollectionView.ScrollDirection, with decorationInitials: CollectionViewDecoratorViewInitialsDefinerType) {
        if scrollDirection == .vertical {
            self.actualLineSpacing = self.lineSpacing
                + decorationInitials.occupiedSpaceInTop()
                + decorationInitials.occupiedSpaceInBottom()
        }else {
            self.actualLineSpacing = self.lineSpacing
                + decorationInitials.occupiedSpaceInLeft()
                + decorationInitials.occupiedSpaceInRight()
        }
    }
            
    fileprivate func getPracticalItemWidth(with width: CGFloat, decorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType)
        -> CGFloat {
        let totalInterItemSpacing = CGFloat(self.noOfTimesItemSpacingNeedToAppear())  * self.actualInterItemSpacing
        
        let actualAvailableSpace = width - totalInterItemSpacing
        
        let practicalSingleBlockWidth = CGFloat(actualAvailableSpace / CGFloat(self.actualNoOfItemsInRow)).rounded(.down)
        
        return practicalSingleBlockWidth
    }
    
    fileprivate func makeAdjustmentToInitialsWithCurrentSetup(layoutWidth: CGFloat, itemWidth: CGFloat) {
        self.actualItemWidth = itemWidth > CGFloat.zero ? itemWidth : CGFloat.zero
        let neededSpaceForItems = (CGFloat(self.actualNoOfItemsInRow) * self.actualItemWidth)
        let totalAdjustableSpace = layoutWidth - neededSpaceForItems
        
        // Try to adjust inter item spacing
        let numberOfTimesItemNeedToAppear = self.noOfTimesItemSpacingNeedToAppear()
        if numberOfTimesItemNeedToAppear > 0 {
            self.actualInterItemSpacing = (totalAdjustableSpace / CGFloat(numberOfTimesItemNeedToAppear)).rounded(.down)
        }else {
            self.unadjustableSpace = totalAdjustableSpace
        }
    }
        
    
    fileprivate func tryToAdjustInitials(forWidth width: CGFloat, decorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType) {
        guard width >= CGFloat.zero else {
            return
        }
        
        let practicalSingleItemWidth = self.getPracticalItemWidth(with: width, decorationInitialsDefiner: decorationInitialsDefiner)
        
        guard practicalSingleItemWidth >= self.expectedItemWidth else {
            // Don't reduce no of items, if there is only one item in the row
            if self.actualNoOfItemsInRow == 1 {
                self.makeAdjustmentToInitialsWithCurrentSetup(layoutWidth: width, itemWidth: practicalSingleItemWidth)
                log(object: "CVCellLayoutInitials: Cannot match expected item width with current bounds and decoration!")
                return
            }
            
            // Reduce no of items in a row
            // And try to adjust item width again
            self.actualNoOfItemsInRow -= 1
            self.tryToAdjustInitials(forWidth: width, decorationInitialsDefiner: decorationInitialsDefiner)
            
            return
        }
        
        self.makeAdjustmentToInitialsWithCurrentSetup(layoutWidth: width, itemWidth: self.expectedItemWidth)
    }
}

extension CollectionViewCellLayoutInitials: CollectionViewCellLayoutInitialsDefinerType {
    func prepare(for scrollDirection: UICollectionView.ScrollDirection, bounds: CGSize, decorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType) {
        self.adjustInterItemSpacing(for: scrollDirection, with: decorationInitialsDefiner)
        self.adjustLineSpacing(for: scrollDirection, with: decorationInitialsDefiner)
        
        if scrollDirection == .vertical {
            self.tryToAdjustInitials(forWidth: bounds.width, decorationInitialsDefiner: decorationInitialsDefiner)
        }
    }
    
    func getUnadjustableSpaceAfterInitialsAdjustment() -> CGFloat {
        return self.unadjustableSpace
    }
    
    func finalise() {}
        
    func getInterItemSpacing() -> CGFloat {
        return self.actualInterItemSpacing
    }
    
    func getLineSpacing() -> CGFloat {
        return self.actualLineSpacing
    }
    
    func getItemWidth() -> CGFloat {
        return self.actualItemWidth
    }
    
    func getNoOfItemsInRow() -> Int {
        return self.actualNoOfItemsInRow
    }
}

