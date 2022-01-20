//
// Created by Apps AS on 01/02/16.
// Copyright (c) 2016 All rights reserved.
//
// ABSTRACT CLASS, LOGIC
// A generic base class for rendering a news feed component for displaying.

import Foundation
import UIKit

class PartRendererBase<T:FeedPart>: PartRendering {

    var cellReuseId: String {
        return "..."
    }

    var nibName: String {
        return "..."
    }

    var cellClass: AnyClass {
        return UITableViewCell.self
    }

    let part: T
    var myTableView: UITableView!
    var myRenderingIndexPath: IndexPath!

    init (part: T) {
        self.part = part
    }

    func render(_ tableView: UITableView, indexPath: IndexPath, enableIndexPathReusing: Bool) -> UITableViewCell {
        myTableView = tableView
        myRenderingIndexPath = indexPath
        let cell = makeRenderingCell()

        if var widthConstrainedCell = cell as? TableViewCellWidthSizing {
            widthConstrainedCell.cellOffset = part.displayingOffset
            widthConstrainedCell.cellWidth = part.displayingWidth
        }

        if enableIndexPathReusing {
            if var reuseSupporterCell = cell as? TableViewCellReusing {
                if reuseSupporterCell.representingIndexPath == myRenderingIndexPath {
                    return cell
                }
                reuseSupporterCell.representingIndexPath = myRenderingIndexPath
            }
        }

        doInitialization(cell)
        doRendering(cell)

        return cell
    }

    func makeRenderingCell() -> UITableViewCell {
        var cell = myTableView?.dequeueReusableCell(withIdentifier: cellReuseId)
        if cell == nil {
            if nibName != "" {
                myTableView?.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellReuseId)
            } else {
                myTableView?.register(cellClass, forCellReuseIdentifier: cellReuseId)
            }
            cell = myTableView?.dequeueReusableCell(withIdentifier: cellReuseId, for: myRenderingIndexPath)
        }

        return cell!
    }

    func doInitialization(_ cell: UITableViewCell) {
      // implement in descendant
    }

    func doRendering(_ cell: UITableViewCell) {
        // implement in descendant
    }
}
