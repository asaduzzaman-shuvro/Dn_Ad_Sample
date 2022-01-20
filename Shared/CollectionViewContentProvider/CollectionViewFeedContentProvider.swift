//
//  CollectionViewFeedContentProvider.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewFeedContentProvider: CollectionViewFeedContentProviding {
    
    fileprivate var sectionInfos = [CollectionViewSectionInfoProviding] ()
    fileprivate let rendererFactory: CollectionViewPartRendererFactory
    fileprivate var neededHeightForLayout: CGFloat = .zero
    fileprivate var needToCalculateNeededHeight: Bool = true
    
    fileprivate var itemsToBeReloaded = [IndexPath] ()
    fileprivate var itemsToBeInserted = [IndexPath] ()
    fileprivate var itemsToBeRemoved = [IndexPath] ()
    
    fileprivate var debouncer: Debouncer = Debouncer(seconds: 0.5, onQueue: DispatchQueue(label: "VideoPlayCheckingQueue"))
    
    init(rendererFactory: CollectionViewPartRendererFactory) {
        self.rendererFactory = rendererFactory
    }
    
    func numberOfSections() -> Int {
        return sectionInfos.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        guard sectionInfos.indices.contains(section) else {
            return 0
        }
        
        return sectionInfos[section].getContentCount()
    }
    
    func getContent(at indexPath: IndexPath) -> CollectionViewFeedPart? {
        guard sectionInfos.indices.contains(indexPath.section) else {
            return nil
        }
        
        return sectionInfos[indexPath.section].getContent(at: indexPath.row)
    }
    
    func getCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < self.numberOfItems(inSection: indexPath.section) else {
            fatalError("CollectionViewFeedContentProvider: Invalid index path to retrieve cell!")
        }
        
        var cell: UICollectionViewCell
        let part = self.getContent(at: indexPath)
        let renderer = rendererFactory.newRenderer(forPart: part!, indexPath: indexPath)
        cell = renderer.render(collectionView)        
        return cell
    }
    
    func updateVideoPlaying(in collectionView: UICollectionView?) {
        self.updateVideoPlaying(for: collectionView)
    }
    
    func updateSectionInfo(with sectionInfos: [CollectionViewSectionInfoProviding]) {
        self.sectionInfos = sectionInfos
        self.needToCalculateNeededHeight = true
    }
    
    func adjustHeightForDynamicContent(at indexPath: IndexPath, height: CGFloat) {
        guard sectionInfos.indices.contains(indexPath.section) else {
            return
        }
        
        self.sectionInfos[indexPath.section].adjustHeightForDynamicContent(at: indexPath.row, height: height)
        self.needToCalculateNeededHeight = true
    }
    
    func necessaryHeightForLayout(for scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        if self.needToCalculateNeededHeight {
            var neededHeight: CGFloat = .zero
            
            if scrollDirection == .vertical {
                self.sectionInfos.forEach {
                    neededHeight += $0.getNecessaryHeightForLayout()
                }
            }else {
                self.sectionInfos.forEach {
                    let sectionHeight = $0.getNecessaryHeightForLayout()
                    if sectionHeight > neededHeight {
                        neededHeight = sectionHeight
                    }
                }
            }

            self.neededHeightForLayout = neededHeight
            self.needToCalculateNeededHeight = false
        }
        
        
        return self.neededHeightForLayout
    }
    
    func getSectionInfo(section: Int) -> CollectionViewSectionInfoProviding? {
        guard sectionInfos.indices.contains(section) else {
            return nil
        }
        
        return sectionInfos[section]
    }
    
    func getSectionHeaderPart(for section: Int) -> CollectionViewFeedPart? {
        return sectionInfos[section].getSectionHeaderPart()
    }
    
    func getSectionHeaderView(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView
        let part = self.getSectionHeaderPart(for: indexPath.section)
        let renderer = rendererFactory.sectionRendeer(forPart: part!, indexPath: indexPath)
        reusableView = renderer.renderReusableView(collectionView)
        return reusableView
    }
}

extension CollectionViewFeedContentProvider {
    func prepareForItemReload(at indexPath: IndexPath, item: CollectionViewFeedPart) {
        guard indexPath.section >= 0 && indexPath.section <= self.sectionInfos.endIndex else {
            fatalError("CollectionViewContentProvider: Invalid index path to reload item!")
        }

        self.sectionInfos[indexPath.section].reloadContent(content: item, index: indexPath.row)
        self.itemsToBeReloaded.append(indexPath)
        self.needToCalculateNeededHeight = true
    }
    
    func getItemsToBeReloaded() -> [IndexPath] {
        return self.itemsToBeReloaded
    }
    
    func prepareForItemInsertion(at indexPath: IndexPath, item: CollectionViewFeedPart) {
        guard indexPath.section >= 0 && indexPath.section < self.sectionInfos.endIndex else {
            fatalError("CollectionViewContentProvider: Invalid index path to insert item!")
        }

        self.sectionInfos[indexPath.section].insertContent(content: item, index: indexPath.row)
        self.itemsToBeInserted.append(indexPath)
        self.needToCalculateNeededHeight = true
    }
    
    func prepareForItemsInsertion(startingAt indexPath: IndexPath, items: [CollectionViewFeedPart]) {
        guard indexPath.section >= 0 && indexPath.section < self.sectionInfos.endIndex else {
            fatalError("CollectionViewContentProvider: Invalid index path to insert item!")
        }
        
        self.sectionInfos[indexPath.section].insertContents(contents: items, at: indexPath.row)
        items.enumerated().forEach({self.itemsToBeInserted.append(IndexPath(row: $0.offset + indexPath.row, section: indexPath.section))})
        self.needToCalculateNeededHeight = true
    }
    
    func getItemsToBeInserted() -> [IndexPath] {
        return self.itemsToBeInserted
    }
    
    func prepareForItemRemoval(at indexPath: IndexPath) {
        guard indexPath.section >= 0 && indexPath.section <= self.sectionInfos.endIndex else {
            fatalError("CollectionViewContentProvider: Invalid index path to delete item!")
        }

        self.sectionInfos[indexPath.section].removeContent(atIndex: indexPath.row)
        self.itemsToBeRemoved.append(indexPath)
        self.needToCalculateNeededHeight = true
    }
    
    func getItemsToBeRemoved() -> [IndexPath] {
        return self.itemsToBeRemoved
    }
        
    func clearUpdateStatusInfo() {
        self.itemsToBeReloaded = []
        self.itemsToBeInserted = []
        self.itemsToBeRemoved = []
    }
}

extension CollectionViewFeedContentProvider: CollectionViewFlowLayoutInfoProvider {
    
    func collectionView(_ collectionView: UICollectionView?, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getSectionInfo(section: indexPath.section)?.getContentSize(at: indexPath.row) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView?, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.getSectionInfo(section: section)?.getSectionInset() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView?, referenceSizeForHeaderIn section: Int) -> CGSize {
        return self.getSectionInfo(section: section)?.getHeaderReferenceSize() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView?, referenceSizeForFooterIn section: Int) -> CGSize {
        return self.getSectionInfo(section: section)?.getFooterReferenceSize() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView?, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.getSectionInfo(section: section)?.getMinimumInterItemSpacing() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView?, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.getSectionInfo(section: section)?.getMinimumLineSpacing() ?? .zero
    }
    
    func collectionView(widthNeededForLayoutAtSection section: Int) -> CGFloat {
        return self.getSectionInfo(section: section)?.getNecessaryWidthForLayout() ?? .zero
    }
    
    func collectionView(heightNeededForLayoutAtSection section: Int) -> CGFloat {
        return self.getSectionInfo(section: section)?.getNecessaryHeightForLayout() ?? .zero
    }

    func collectionView(sectionDecorationDefinerAtSection section: Int) -> CollectionViewDecoratorViewInitialsDefinerType? {
        return self.getSectionInfo(section: section)?.getSectionDecorationInfoProvider()
    }
    
    func collectionView(itemDecorationDefinerAtSection section: Int) -> CollectionViewDecoratorViewInitialsDefinerType? {
        return self.getSectionInfo(section: section)?.getItemDecorationInfoProvider()
    }
    
    func collectionView(noOfItemsInRowAtSection section: Int) -> Int? {
        return self.getSectionInfo(section: section)?.getNoOfContentInRows()
    }
    
    func collectionView(totalRowsAtSection section: Int) -> Int? {
        return self.getSectionInfo(section: section)?.getRowCount()
    }
}

extension CollectionViewFeedContentProvider {
    private func updateVideoPlaying(for collectionView: UICollectionView?) {
        debouncer.debounce(action: {
        }, cancelBlock: nil)
    }
}
