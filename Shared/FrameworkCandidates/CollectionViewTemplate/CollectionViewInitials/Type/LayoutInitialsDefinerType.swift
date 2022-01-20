//
//  LayoutInitialsDefinerType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol LayoutInitialsDefinerType: AnyObject {
    func prepare(with bounds: CGSize, for scrollDirection: UICollectionView.ScrollDirection)
}

extension LayoutInitialsDefinerType {
    func prepare(with bounds: CGSize, for scrollDirection: UICollectionView.ScrollDirection) {}
}
