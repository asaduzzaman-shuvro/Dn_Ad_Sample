//
//  CollectionViewFeedPart.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

/// Part that represents portion of the feed in the app.
class CollectionViewFeedPart: CollectionViewPart {
    
    /// Unique identifier of the part.
    var uID = UUID()
    
    /// Background color of the part.
    var backgroundColor: UIColor = .clear
    
    /// Boolean controlling rounding of top portion of the part.
    var topRounding: Bool = false
    
    /// Boolean controlling rounding of bottom portion of the part.
    var bottomRounding: Bool = false
}
