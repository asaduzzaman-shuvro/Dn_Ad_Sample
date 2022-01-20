//
// Created by ALi.apps.no on 19/01/16.
// Copyright (c) 2016 ALi.apps.no. All rights reserved.
//
// PURE DATA
// Represents the news feed entity app displaying as the main screen.

import Foundation

class Feed {

    let updateAt: Date
    let issue: String
    var components: [Component]

    init (updateAt: Date, issue: String, components: [Component]) {
        self.updateAt = updateAt
        self.issue = issue
        self.components = components
    }
}
