//
// Created by Apps AS on 26/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

class GeneralPartRenderer: PartRendererBase<FeedPart> {

//    var factboxIndex: Int = 0
    override var cellReuseId: String {
//        var cellReuseId = ""
//        cellReuseId = part.cellReuseId
//        if let myPart = part as? FactBoxPart{
//            factboxIndex += 1
//            cellReuseId = "\(myPart.cellReuseId)\(factboxIndex)"
//        }
        return part.cellReuseId
//        return cellReuseId
    }

    override var nibName: String {
        return part.cellNibName
    }

    override var cellClass: AnyClass {
        return part.cellClass
    }


    override init(part: FeedPart) {
        super.init(part: part)
    }

    override func doRendering(_ cell: UITableViewCell) {
        super.doRendering(cell)
        guard let partDisplayingCell = cell as? PartDisplaying else {
            return
        }

        partDisplayingCell.displayPart(part)
    }
}
