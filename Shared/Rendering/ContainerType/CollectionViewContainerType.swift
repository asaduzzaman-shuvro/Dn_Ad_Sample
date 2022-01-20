//
//  CollectionViewContainerType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewContainerType: AnyObject {
    func getCollectionView() -> UICollectionView?
    func getCollectionViewScrollDirection() -> UICollectionView.ScrollDirection
    func getCollectionViewBounds() -> CGSize
    func reload(with sectionInfos: [CollectionViewSectionInfoProviding])
    func reload()
    func adjustHeightForDynamicContent(at indexPath: IndexPath, height: CGFloat)
}
