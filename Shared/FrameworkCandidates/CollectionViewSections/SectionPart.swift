//
//  SectionPart.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class SectionPart {
    let sectionInitialsDefiner: CollectionViewSectionLayoutInitialsDefinerType
    var parts: [CollectionViewFeedPart]
    
    init(sectionInitalsDefiner: CollectionViewSectionLayoutInitialsDefinerType, parts: [CollectionViewFeedPart]) {
        self.sectionInitialsDefiner = sectionInitalsDefiner
        self.parts = parts
    }
}

extension SectionPart: CollectionViewSectionInfoProviding {
    func getContentCount() -> Int {
        return parts.count
    }
    
    func getContentSize(at index: Int) -> CGSize {
        return sectionInitialsDefiner.getContentSize(at: index)
    }
    
    func getContents() -> [CollectionViewFeedPart] {
        return self.parts
    }
    
    func update(contents: [CollectionViewFeedPart]) {
        self.parts = contents
        self.sectionInitialsDefiner.update(contentHeights: contents.map{$0.size.height})
    }
    
    func getContent(at index: Int) -> CollectionViewFeedPart? {
        guard parts.indices.contains(index) else {
            return nil
        }
        
        return parts[index]
    }
    
    func getNoOfContentInRows() -> Int {
        return self.sectionInitialsDefiner.getNoOfItemsInRow()
    }
    
    func getRowCount() -> Int {
        return self.sectionInitialsDefiner.getRowCount()
    }
    
    func adjustHeightForDynamicContent(at index: Int, height: CGFloat) {
        guard index.isValidIndex(in: self.parts) else {
            log(object: "SectionPart: Invalid index to change content height!")
            return
        }
        
        self.parts[index].changeHeight(height)
        self.sectionInitialsDefiner.adjustHeightForDynamicContent(at: index, height: height)
    }
    
    func getNecessaryWidthForLayout() -> CGFloat {
        return self.sectionInitialsDefiner.getNecessaryWidthForLayout()
    }
    
    func getNecessaryHeightForLayout() -> CGFloat {
        return self.sectionInitialsDefiner.getNecessaryHeightForLayout()
    }
    
    func getSectionInset() -> UIEdgeInsets {
        return sectionInitialsDefiner.getSectionInset()
    }
    
    func getHeaderReferenceSize() -> CGSize {
        return sectionInitialsDefiner.getSupplementaryViewHeaderSize()
    }
    
    func getFooterReferenceSize() -> CGSize {
        return sectionInitialsDefiner.getSupplementaryViewFooterSize()
    }
    
    func getSectionHeaderPart() -> CollectionViewFeedPart? {
        return sectionInitialsDefiner.getSupplimentaryViewProvidder().getHeaderPart()
    }
    
    func getMinimumInterItemSpacing() -> CGFloat {
        return sectionInitialsDefiner.getMinimumInterItemSpacing()
    }
    
    func getMinimumLineSpacing() -> CGFloat {
        return sectionInitialsDefiner.getLineSpacing()
    }
    
    func getSectionDecorationInfoProvider() -> CollectionViewDecoratorViewInitialsDefinerType {
        return sectionInitialsDefiner.getSectionDecorationInfoProvider()
    }
    
    func getItemDecorationInfoProvider() -> CollectionViewDecoratorViewInitialsDefinerType {
        return sectionInitialsDefiner.getItemDecorationInfoProvider()
    }
    
    func reloadContent(content: CollectionViewFeedPart, index: Int) {
        guard index.isValidIndex(in: self.parts) else {
            log(object: "SectionPart: Invalid index to reload content!")
            return
        }

        let oldContent = self.parts[index]
        self.parts[index] = content
        self.sectionInitialsDefiner.contentReloaded(at: index, contentHeight: content.size.height)
        self.updateInternalsAfterReload(newContent: content, oldContent: oldContent)
    }
    
    func insertContent(content: CollectionViewFeedPart, index: Int) {
        guard index.isValidIndex(in: self.parts) else {
            log(object: "SectionPart: Invalid index to insert content!")
            return
        }

        self.parts.insert(content, at: index)
        self.sectionInitialsDefiner.contentAdded(at: index, contentHeight: content.size.height)
        self.updateInternalsAfterInsert(indexOffset: 1, from: index)
    }
    
    func insertContents(contents: [CollectionViewFeedPart], at index: Int) {
        guard index.isValidIndex(in: self.parts) else {
            log(object: "SectionPart: Invalid index to start inserting contents!")
            return
        }
        
        self.parts.insert(contentsOf: contents, at: index)
        self.sectionInitialsDefiner.contentsAdded(at: index, contentHeights: contents.map{$0.size.height})
        self.updateInternalsAfterInsert(indexOffset: contents.count, from: index)
    }
    
    func removeContent(atIndex index: Int) {
        guard index.isValidIndex(in: self.parts) else {
            log(object: "SectionPart: Invalid index to delete content!")
            return
        }

        self.parts.remove(at: index)
        self.sectionInitialsDefiner.contentRemoved(at: index)
        self.updateInternalsAfterRemove(from: index)
    }
}
