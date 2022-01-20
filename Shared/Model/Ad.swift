//
// Created by Apps AS on 26/01/16.
// Copyright (c) 2016 All rights reserved.
//
// PURE DATA
// Represents an Ad front page entry.

import Foundation
import  UIKit

class Ad: Component {

    enum AdSize: String {
        case Small = "Small"
        case Medium = "Medium"
        case Large = "Large"

        static func SizeFromString(_ string: String) -> AdSize {
            switch string {
                case "large":
                    return Large
                case "medium":
                    return Medium
                default:
                    return Small
            }
        }
    }

    let provider : String
    let adHeight : CGFloat
    let alias : String

    let placeholderImage: Image

    var isEmpty: Bool {
        return false
    }

    init (provider: String, adHeight: CGFloat, alias: String, placeholderImage: Image) {
        self.provider = provider
        self.adHeight = adHeight
        self.alias = alias
        self.placeholderImage = placeholderImage
    }
}
