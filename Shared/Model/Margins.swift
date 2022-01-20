//
// Created by Apps AS on 25/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

class Margins {

    var top: CGFloat
    var bottom: CGFloat
    var left: CGFloat
    var right: CGFloat

    init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
    }

    convenience init(sideMargins: SideMargins, topMargin: CGFloat) {
        self.init(top: topMargin, bottom: 0, left: sideMargins.left, right: sideMargins.right)
    }

    convenience init() {
        self.init(top: 0, bottom:0, left: 0, right: 0)
    }

    func updateTop(_ top: CGFloat) {
        self.top = top
    }

    func updateBottom(_ bottom: CGFloat) {
        self.bottom = bottom
    }
}


class SideMargins {

    static var emptyMargins = SideMargins(left: 0, right: 0)

    let left: CGFloat
    let right: CGFloat

    convenience init() {
        self.init(left: 12, right: 12)
    }

    init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
}
