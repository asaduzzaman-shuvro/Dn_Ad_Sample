//
// Created by Apps AS on 09/05/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

protocol FeedAppearanceProviding {

    var screenWidth: CGFloat {get}
    var introPageMargin: CGFloat { get }
    var feedMargin: CGFloat { get }
    var topImageHeight: CGFloat { get }
    var inlineVideoHeight: CGFloat { get }
    var feedWidth: CGFloat { get }
    var articleMargin: CGFloat { get }
    var newsFeedBackgroundColor: UIColor { get }
    var articleDetailsBackgroundColor: UIColor { get }
    var fullscreenAdBackgroundColor: UIColor { get }
    var fordelFeedBackgroundColor: UIColor { get }
    var fordelDetailsBackgroundColor: UIColor { get }
    var feedMarginForFordel: CGFloat { get }
    var feedWidthForFordel: CGFloat { get }
    var articleMarginForFordel: CGFloat { get }
    var isTablet: Bool { get }
    var tableColumnWidth: CGFloat { get }
    var tableColumnNumber: Int { get }

    func adHeightBySize(_ adSize: Ad.AdSize) -> CGFloat

}
