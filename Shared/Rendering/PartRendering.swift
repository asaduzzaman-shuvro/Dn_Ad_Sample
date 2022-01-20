//
// Created by Apps AS on 26/01/16.
// Copyright (c) 2016 All rights reserved.
//
// INTERFACE
// Define a unified interface for rendering front page entries.

import Foundation
import UIKit

protocol PartRendering: AnyObject {

    func render(_ tableView: UITableView, indexPath: IndexPath, enableIndexPathReusing: Bool) -> UITableViewCell
}
