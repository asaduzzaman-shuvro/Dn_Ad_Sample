//
//  DynamicContentCellDelegate.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol DynamicContentCellDelegate: AnyObject {
    func adjustHeightForDynamicContent(at indexPath: IndexPath, height: CGFloat)
}

protocol EditingContainerDynamicContentCellDelegate: AnyObject {
    func adjustHeightForDynamicContent(cell: UICollectionViewCell, height: CGFloat)
}
