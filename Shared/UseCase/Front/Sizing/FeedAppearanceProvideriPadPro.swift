//
// Created by Apps AS on 09/05/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

class FeedAppearanceProvideriPadPro: FeedAppearanceProviding {

    var screenWidth: CGFloat{
        return UIScreen.main.bounds.width
    }
    
    var topImageHeight: CGFloat {
        let availableWidth = screenWidth - (feedMargin * 2)
        let height = availableWidth * (214/375)
        return height
    }
    
    var inlineVideoHeight : CGFloat{
        return topImageHeight
    }
    
    
    var feedMargin: CGFloat {
        return 94
    }

    var feedWidth: CGFloat {
        return 836
    }
    
    var introPageMargin: CGFloat{
        return 100
    }

    var articleMargin: CGFloat {
        return 90
    }
    
    var feedMarginForFordel: CGFloat {
        return 94
    }
    var feedWidthForFordel: CGFloat {
        return 836
    }
    
    var articleMarginForFordel: CGFloat {
        return 90
    }

    var newsFeedBackgroundColor: UIColor {
        return UIColor.picturePlaceholderColor()
    }
    
    var articleDetailsBackgroundColor: UIColor {
//        return UIColor.picturePlaceholderColor()
        return UIColor.black
    }
    
    var fullscreenAdBackgroundColor: UIColor {
        return UIColor.black
    }

    var fordelFeedBackgroundColor: UIColor {
        return UIColor.picturePlaceholderColor()
//        return UIColor.black
    }
    var fordelDetailsBackgroundColor: UIColor {
        return UIColor.picturePlaceholderColor()
//        return UIColor.black
    }

    var isTablet: Bool {
        return true
    }
    
    var tableColumnNumber: Int {
        return 4
    }

    var tableColumnWidth: CGFloat {
        let tableWidth = self.screenWidth - ((self.articleMargin - 5) * 2)
        return (tableWidth/4)
    }
    
    func adHeightBySize(_ adSize: Ad.AdSize) -> CGFloat {
        switch adSize {
            case .Large:
                return 320
            case .Medium:
                return 160
            default:
                return 50
        }
    }

}
