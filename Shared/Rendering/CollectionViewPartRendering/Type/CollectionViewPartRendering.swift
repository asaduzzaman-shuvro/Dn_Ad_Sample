//
//  CollectionViewPartRendering.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewPartRendering: AnyObject {
    func render(_ collectionView: UICollectionView) -> UICollectionViewCell
    func renderReusableView(_ collectionView: UICollectionView) -> UICollectionReusableView 
}
