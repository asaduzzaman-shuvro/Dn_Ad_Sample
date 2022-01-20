//
//  CollectionViewCustomLayout.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCustomLayout: UICollectionViewFlowLayout {
    fileprivate let itemDecorationViewKinds = [
        "CollectionViewSeparatorView.Top",
        "CollectionViewSeparatorView.Left",
        "CollectionViewSeparatorView.Bottom",
        "CollectionViewSeparatorView.Right"
    ]
    
    fileprivate let sectionDecorationViewKinds = [
        "CollectionViewSeparatorView.Section"
    ]
    
    var infoProvider: CollectionViewFlowLayoutInfoProvider!
    
    override init() {
        super.init()
        
        self.registerDecorationViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.registerDecorationViews()
    }
    
    func registerDecorationViews() {
        self.itemDecorationViewKinds.forEach { register(CollectionViewItemSeparatorView.self, forDecorationViewOfKind: $0)}
        self.sectionDecorationViewKinds.forEach { register(CollectionViewSectionSeparatorView.self, forDecorationViewOfKind: $0)}
    }
    
    override func prepare() {
        super.prepare()
    
        if #available(iOS 11, *){
            self.sectionInsetReference = .fromSafeArea
        }
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var frame = CGRect.zero
        
        guard let itemDecorationInfoProvider = self.infoProvider.collectionView(itemDecorationDefinerAtSection: indexPath.section) else {
            return nil
        }
        
        if let rows = collectionView?.numberOfItems(inSection: indexPath.section), indexPath.row < rows {
            if let cellAttribute = layoutAttributesForItem(at: indexPath){
                frame = cellAttribute.frame
            }
        }
        
        if elementKind == sectionDecorationViewKinds[0] {
            return self.layoutAttrbiutesForSectionDecoration(ofKind: elementKind, at: indexPath, referenceFrame: frame)
        }
        
        let itemDecorationStyle = itemDecorationInfoProvider.decoratorViewStyle()
        let itemDecorationWidth = itemDecorationInfoProvider.decoratorViewWidth()
        let itemDecorationColor = itemDecorationInfoProvider.decoratorViewColor()
        let itemDecorationPadding = itemDecorationInfoProvider.decoratorViewPadding()
        let itemDecorationPaddingHalf = self.calculateHalfPadding(itemDecorationPadding)
        
        guard itemDecorationStyle != .none && itemDecorationWidth > .zero else {
            return nil
        }

        let attribute = CollectionViewSeparatorLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        
        switch elementKind {
        case itemDecorationViewKinds[0]:
            // Item Decoration Top
            guard itemDecorationStyle == .around || itemDecorationStyle == .topBottom else {
                break
            }
            
            let width = self.getNonNegative(frame.width - itemDecorationPadding)
            
            guard width > .zero else {
                return nil
            }

            attribute.frame = CGRect(x: frame.minX + itemDecorationPaddingHalf,
                                     y: frame.minY - itemDecorationWidth,
                                     width: width,
                                     height: itemDecorationWidth)
        case itemDecorationViewKinds[1]:
            // Item Decoration Left
            guard itemDecorationStyle == .around || itemDecorationStyle == .leftRight else {
                break
            }

            let height = self.getNonNegative(frame.height + (itemDecorationWidth * 2) - itemDecorationPadding)
            
            guard height > .zero else {
                return nil
            }
            
            attribute.frame = CGRect(x: frame.minX - itemDecorationWidth,
                                     y: frame.minY + itemDecorationPaddingHalf - itemDecorationWidth,
                                     width: itemDecorationWidth,
                                     height: height)
        case itemDecorationViewKinds[2]:
            // Item Decoration Bottom
            guard itemDecorationStyle == .around || itemDecorationStyle == .topBottom || itemDecorationStyle == .interRow else {
                break
            }

            if itemDecorationStyle == .interRow {
                guard self.isFirstElementInRow(indexPath: indexPath) && !self.isItemOfLastRow(indexPath: indexPath) else {
                    break
                }
                
                if let frame = self.calculateAttributeFrameForInterRowDecoration(at: indexPath, itemFrame: frame, width: itemDecorationWidth, padding: itemDecorationPadding) {
                    attribute.frame = frame
                }else {
                    return nil
                }
            }else {
                let width = self.getNonNegative(frame.width - itemDecorationPadding)
                
                guard width > .zero else {
                    return nil
                }
                
                attribute.frame = CGRect(x: frame.minX + itemDecorationPaddingHalf,
                                         y: frame.maxY,
                                         width: width,
                                         height: itemDecorationWidth)
            }
        case itemDecorationViewKinds[3]:
            // Item Decoration Right
            guard itemDecorationStyle == .around || itemDecorationStyle == .leftRight else {
                break
            }

            let height = self.getNonNegative(frame.height + (itemDecorationWidth * 2) - itemDecorationPadding)
            
            guard height > .zero else {
                return nil
            }
            
            attribute.frame = CGRect(x: frame.maxX,
                                     y: frame.minY + itemDecorationPaddingHalf - itemDecorationWidth,
                                     width: itemDecorationWidth,
                                     height: height)
        default:
            return nil
        }
        
        attribute.zIndex = -1
        attribute.separatorColor = itemDecorationColor
        
        return attribute
    }
    
    func layoutAttrbiutesForSectionDecoration(ofKind elementKind: String, at indexPath: IndexPath, referenceFrame: CGRect) -> UICollectionViewLayoutAttributes? {
        guard let sectionDecorationDefiner = self.infoProvider.collectionView(sectionDecorationDefinerAtSection: indexPath.section) else {
            return nil
        }
        
        let sectionDecorationStyle = sectionDecorationDefiner.decoratorViewStyle()
        let sectionDecorationColor = sectionDecorationDefiner.decoratorViewColor()
        let sectionDecorationWidth = sectionDecorationDefiner.decoratorViewWidth()
        
        if sectionDecorationStyle == .none || indexPath.row != 0 {
            return nil
        }
        
        
        var topBottomOffset = CGFloat.zero
        var leftRightOffset = CGFloat.zero
        
        if let itemDecorationInitials = self.infoProvider.collectionView(itemDecorationDefinerAtSection: indexPath.section) {
            
            let itemDecorationStyle = itemDecorationInitials.decoratorViewStyle()
            
            if itemDecorationStyle == .around || itemDecorationStyle == .topBottom {
                topBottomOffset += itemDecorationInitials.decoratorViewWidth()
            }
            
            if itemDecorationStyle == .around || itemDecorationStyle == .leftRight {
                leftRightOffset += itemDecorationInitials.decoratorViewWidth()
            }
        }
                        
        let sectionInset = self.infoProvider.collectionView(self.collectionView, insetForSectionAt: indexPath.section)
        
        var decorationWidth = self.infoProvider.collectionView(widthNeededForLayoutAtSection: indexPath.section)
        var decorationHeight = self.infoProvider.collectionView(heightNeededForLayoutAtSection: indexPath.section)
        
        let headerSize = self.infoProvider.collectionView(self.collectionView, referenceSizeForHeaderIn: indexPath.section)
        let footerSize = self.infoProvider.collectionView(self.collectionView, referenceSizeForFooterIn: indexPath.section)

        if self.scrollDirection == .vertical {
            decorationHeight -= (headerSize.height + footerSize.height)
        }
        
        if self.scrollDirection == .horizontal {
            decorationWidth -= (headerSize.width + footerSize.width)
        }
        
        var minX = referenceFrame.minX
        var minY = referenceFrame.minY
        
        if sectionDecorationStyle == .around {
            minX -= sectionInset.left
            minY -= sectionInset.top
        }
        
        if sectionDecorationStyle == .topBottom {
            decorationWidth -= sectionInset.left + sectionInset.right
            decorationWidth += leftRightOffset * 2
            minX -= leftRightOffset
            minY -= sectionInset.top
        }
        
        if sectionDecorationStyle == .leftRight {
            decorationHeight -= sectionInset.top + sectionInset.bottom
            decorationWidth += topBottomOffset * 2
            minX -= sectionInset.left
            minY -= topBottomOffset
        }
        
        let attributes = CollectionViewSectionSeparatorLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        
        attributes.frame = CGRect(x: minX, y: minY, width: decorationWidth, height: decorationHeight)
        attributes.zIndex = -1
        attributes.separatorStyle = sectionDecorationStyle
        attributes.separatorColor = sectionDecorationColor
        attributes.separatorWidth = sectionDecorationWidth
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let baseAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        var layoutAttributes = baseAttributes
        layoutAttributes.filter{ $0.representedElementCategory == .cell }.forEach { (layoutAttribute) in
            let indexPath = layoutAttribute.indexPath
            
            layoutAttributes += self.itemDecorationViewKinds.compactMap { self.layoutAttributesForDecorationView(ofKind: $0, at: indexPath)}
            layoutAttributes += self.sectionDecorationViewKinds.compactMap { self.layoutAttributesForDecorationView(ofKind: $0, at: indexPath)}
        }
        
        return layoutAttributes
    }
    
    func isItemOfLastRow(indexPath: IndexPath) -> Bool {
        guard let noOfItemsInRow = self.infoProvider.collectionView(noOfItemsInRowAtSection: indexPath.section),
            let noOfRows = self.infoProvider.collectionView(totalRowsAtSection: indexPath.section) else {
            return false
        }
 
        let expectedTotalItems = noOfRows * noOfItemsInRow
        
        return !(indexPath.row <= (expectedTotalItems - noOfItemsInRow) - 1)
    }
    
    func isFirstElementInRow(indexPath: IndexPath) -> Bool {
        guard let noOfItemsInRow = self.infoProvider.collectionView(noOfItemsInRowAtSection: indexPath.section) else {
            return false
        }
        
        return indexPath.row % noOfItemsInRow == 0
    }
    
    func calculateAttributeFrameForInterRowDecoration(at indexPath: IndexPath, itemFrame: CGRect, width: CGFloat, padding: CGFloat) -> CGRect? {
        let interItemDistance = self.infoProvider.collectionView(self.collectionView, minimumLineSpacingForSectionAt: indexPath.section)
        let insetForSection = self.infoProvider.collectionView(self.collectionView, insetForSectionAt: indexPath.section)
        
        var decorationFrameMinX: CGFloat = .zero
        var decorationFrameMinY: CGFloat = .zero
        var decorationWidth: CGFloat = .zero
        var decorationHeight: CGFloat = .zero
        
        let paddingHalf = self.calculateHalfPadding(padding)
        
        if self.scrollDirection == .vertical {
            decorationFrameMinX = itemFrame.minX + paddingHalf
            decorationFrameMinY = itemFrame.maxY + ((interItemDistance / 2) - (width / 2))
            
            let sectionWidth = self.infoProvider.collectionView(widthNeededForLayoutAtSection: indexPath.section)
            decorationWidth =  sectionWidth > .zero ? self.getNonNegative(sectionWidth - insetForSection.left - insetForSection.right - padding) : .zero
            
            decorationHeight = width
            
        }else {
            decorationFrameMinX = itemFrame.maxX + ((interItemDistance / 2) - (width / 2))
            decorationFrameMinY = itemFrame.minY + paddingHalf
            
            decorationWidth = width
            
            let sectionHeight = self.infoProvider.collectionView(heightNeededForLayoutAtSection: indexPath.section)
            decorationHeight = sectionHeight > .zero ? self.getNonNegative(sectionHeight - insetForSection.top - insetForSection.bottom) : .zero
        }
        
        guard decorationWidth > .zero && decorationHeight > .zero else {
            return nil
        }
        
        return CGRect(x: decorationFrameMinX, y: decorationFrameMinY, width: decorationWidth, height: decorationHeight)
    }
    
    fileprivate func calculateHalfPadding(_ padding: CGFloat) -> CGFloat {
        return (padding / 2).rounded(.down)
    }
    
    fileprivate func getNonNegative(_ value: CGFloat) -> CGFloat {
        return value < .zero ? .zero : value
    }
}

