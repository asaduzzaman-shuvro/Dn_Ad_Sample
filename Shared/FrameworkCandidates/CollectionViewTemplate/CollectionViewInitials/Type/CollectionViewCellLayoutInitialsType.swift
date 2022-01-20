//
//  CollectionViewCellLayoutInitialsType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewCellLayoutInitialsType {
    var minimumInterItemSpacing: CGFloat { get }
    var lineSpacing: CGFloat { get }
    var expectedItemWidth: CGFloat { get }
    var expectedNoOfItemsInRow: Int { get }
}

protocol CollectionViewCellLayoutInitialsDefinerType {
    func prepare(for scrollDirection: UICollectionView.ScrollDirection, bounds: CGSize, decorationInitialsDefiner: CollectionViewDecoratorViewInitialsDefinerType)
    func getUnadjustableSpaceAfterInitialsAdjustment() -> CGFloat
    func finalise()
    
    func getInterItemSpacing() -> CGFloat
    func getLineSpacing() -> CGFloat
    func getItemWidth() -> CGFloat
    func getNoOfItemsInRow() -> Int
}
