//
// Created by Apps AS on 15/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

class FeedPart {

    var topRounding = false
    var bottomRounding = false
    var cellReuseId = ""
    var cellNibName = ""
    var cellClass: AnyClass = UITableViewCell.self
    var displayingWidth: CGFloat = UIScreen.main.bounds.width
    var displayingOffset: CGFloat = 0

    var estimatedDisplayingHeight: CGFloat {
        return 44
    }
}
