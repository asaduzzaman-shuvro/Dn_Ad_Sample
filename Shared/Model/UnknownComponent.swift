//
// Created by Apps AS on 28/01/16.
// Copyright (c) 2016 All rights reserved.
//
// PURE DATA, NULL OBJECT
// Represent an unknown component.

import Foundation
import SwiftyJSON

class UnknownComponent: Component {

    let json: JSON

    var isEmpty: Bool {
        return false
    }

    init (json: JSON) {
        self.json = json
    }
}
