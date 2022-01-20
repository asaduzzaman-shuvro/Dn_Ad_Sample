//
//  EditingCollectionViewContainerType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 11/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol EditingCollectionViewContainerType: CollectionViewContainerType {
    func getNumberOfSections() -> Int
    func getNumberOfItems(inSection section: Int) -> Int
    func getLastCell() -> IndexPath?
    func getIndexPath(for cell: UICollectionViewCell) -> IndexPath?
    func reload(part: CollectionViewFeedPart, atIndexPath indexPath: IndexPath)
    func insert(part: CollectionViewFeedPart, atIndexPath indexPath: IndexPath)
    func insert(parts: [CollectionViewFeedPart], startingAt indexPath: IndexPath)
    func removeItem(at indexPath: IndexPath)
    func performUpdates()
}
