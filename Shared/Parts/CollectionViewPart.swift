//
//  CollectionViewPart.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

/// Parent of any collection view part.
class CollectionViewPart: VaryingSizePart {
    
    /// Index path of the part.
    var representingIndexPath = IndexPath()
    
    /// Collection view cell class for the designated part.
    var cellNibName: String = ""
    
    /// /// Collection view cell nib name for the designated part.
    var cellReuseId: String = ""
    
    /// /// Collection view cell reuse identifier for the designated part.
    var cellClass: AnyClass = UICollectionViewCell.self
    
    var supplimentaryClass: AnyClass = UICollectionReusableView.self
    
}
