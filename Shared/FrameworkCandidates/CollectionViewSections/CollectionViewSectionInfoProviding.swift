//
//  CollectionViewSectionInfoProviding.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewSectionInfoProviding {
    func getContentCount() -> Int
    func getContentSize(at index: Int) -> CGSize
    func adjustHeightForDynamicContent(at index: Int, height: CGFloat)
    func getContents() -> [CollectionViewFeedPart]
    func update(contents: [CollectionViewFeedPart])
    func getContent(at index: Int) -> CollectionViewFeedPart?
    func getNoOfContentInRows() -> Int
    func getRowCount() -> Int
    func getNecessaryWidthForLayout() -> CGFloat
    func getNecessaryHeightForLayout() -> CGFloat
    func getSectionInset() -> UIEdgeInsets
    func getHeaderReferenceSize() -> CGSize
    func getFooterReferenceSize() -> CGSize
    func getSectionHeaderPart() -> CollectionViewFeedPart?
    func getMinimumInterItemSpacing() -> CGFloat
    func getMinimumLineSpacing() -> CGFloat
    func getSectionDecorationInfoProvider() -> CollectionViewDecoratorViewInitialsDefinerType
    func getItemDecorationInfoProvider() -> CollectionViewDecoratorViewInitialsDefinerType
    func reloadContent(content: CollectionViewFeedPart, index: Int)
    func insertContent(content: CollectionViewFeedPart, index: Int)
    func insertContents(contents: [CollectionViewFeedPart], at index: Int)
    func removeContent(atIndex index: Int)
}

extension CollectionViewSectionInfoProviding {
    func updateInternalsAfterReload(newContent: CollectionViewFeedPart, oldContent: CollectionViewFeedPart) {
        newContent.uID = oldContent.uID
        newContent.representingIndexPath = oldContent.representingIndexPath
    }
    
    func updateInternalsAfterInsert(indexOffset: Int, from index: Int) {
        let contents = self.getContents()
        var newContents = Array(contents[0..<index+1])
        
        newContents.append(contentsOf: contents[index+1..<contents.endIndex].map({
            let currentIndexPath = $0.representingIndexPath
            if !currentIndexPath.isEmpty {
                $0.representingIndexPath = IndexPath(row: currentIndexPath.row + indexOffset, section: currentIndexPath.section)
            }
            return $0
        }))
        
        self.update(contents: newContents)
    }
    
    func updateInternalsAfterRemove(from index: Int) {
        let contents = self.getContents()
        
        var newContents = Array(contents[0..<index])
        
        newContents.append(contentsOf: contents[index..<contents.endIndex].map({
            let currentIndexPath = $0.representingIndexPath
            if !currentIndexPath.isEmpty {
                $0.representingIndexPath = IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)
            }
            return $0
        }))
        
        self.update(contents: newContents)
    }
}
