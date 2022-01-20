//
//  CollectionViewFlowLayoutInfoProvider.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewFlowLayoutInfoProvider {
    func collectionView(_ collectionView: UICollectionView?, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView?, insetForSectionAt section: Int) -> UIEdgeInsets
    func collectionView(_ collectionView: UICollectionView?, referenceSizeForHeaderIn section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView?, referenceSizeForFooterIn section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView?, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    func collectionView(_ collectionView: UICollectionView?, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(widthNeededForLayoutAtSection section: Int) -> CGFloat
    func collectionView(heightNeededForLayoutAtSection section: Int) -> CGFloat
    func collectionView(sectionDecorationDefinerAtSection section: Int) -> CollectionViewDecoratorViewInitialsDefinerType?
    func collectionView(itemDecorationDefinerAtSection section: Int) -> CollectionViewDecoratorViewInitialsDefinerType?
    func collectionView(noOfItemsInRowAtSection section: Int) -> Int?
    func collectionView(totalRowsAtSection section: Int) -> Int?
}
