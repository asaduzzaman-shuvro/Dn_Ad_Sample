//
// Created by Apps AS on 22/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation

class Image {

    static let emptyImage = Image(photographerName: "", caption: "", descriptors: [])

    let photographerName: String
    let caption: String
    let descriptors: [ImageDescriptor]

    init(photographerName: String, caption: String, descriptors:[ImageDescriptor]) {
        self.photographerName = photographerName
        self.caption = caption
        self.descriptors = descriptors
    }
}
