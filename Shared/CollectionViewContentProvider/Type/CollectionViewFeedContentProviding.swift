//
//  CollectionViewFeedContentProviding.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewFeedContentProviding {
    func getContent(at indexPath: IndexPath) -> CollectionViewFeedPart?
    func numberOfSections() -> Int
    func numberOfItems(inSection section: Int) -> Int
    func getCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func updateVideoPlaying(in collectionView: UICollectionView?)
    
    func updateSectionInfo(with sectionInfos: [CollectionViewSectionInfoProviding])
    func adjustHeightForDynamicContent(at indexPath: IndexPath, height: CGFloat)
    func necessaryHeightForLayout(for scrollDirection: UICollectionView.ScrollDirection) -> CGFloat
    
    func prepareForItemReload(at indexPath: IndexPath, item: CollectionViewFeedPart)
    func getItemsToBeReloaded() -> [IndexPath]
    func prepareForItemInsertion(at indexPath: IndexPath, item: CollectionViewFeedPart)
    func prepareForItemsInsertion(startingAt indexPath: IndexPath, items: [CollectionViewFeedPart])
    func getItemsToBeInserted() -> [IndexPath]
    func prepareForItemRemoval(at indexPath: IndexPath)
    func getItemsToBeRemoved() -> [IndexPath]
    func clearUpdateStatusInfo()
    
    func getSectionHeaderPart(for section: Int) -> CollectionViewFeedPart?
    func getSectionHeaderView(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView
}
