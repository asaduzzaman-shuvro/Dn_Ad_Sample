//
// Created by Apps AS on 09/05/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    static let minimumImageSize: CGFloat = 214
    static let minimumVideoSize: CGFloat = 234
}

class FeedAppearanceProvideriPhone: FeedAppearanceProviding {
    
    var topImageHeight: CGFloat {
        return AppConstants.minimumImageSize
    }
    
    var inlineVideoHeight : CGFloat{
        return AppConstants.minimumVideoSize
    }

    var feedMargin: CGFloat {
        return 0
    }

    var feedWidth: CGFloat {
        return screenWidth
    }
    
    var screenWidth: CGFloat{
        return UIScreen.main.bounds.width
    }

    var introPageMargin: CGFloat{
        return 40
    }
    
    var articleMargin: CGFloat {
        return 30
    }
    
    var feedMarginForFordel: CGFloat {
        return 15
    }
    var feedWidthForFordel: CGFloat {
        return screenWidth - 30
    }
    
    var articleMarginForFordel: CGFloat {
        return 30
    }

    var newsFeedBackgroundColor: UIColor {
        return UIColor.black
    }
    
    var articleDetailsBackgroundColor: UIColor {
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
        return false
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
    
    var tableColumnNumber: Int {
        if self.screenWidth < 375{
            return 3
        }
        return 4
        
    }
    
    var tableColumnWidth: CGFloat {
        
        let tableWidth = self.screenWidth - ((self.articleMargin - 5) * 2)
        
        if self.screenWidth < 375{
            return (tableWidth/2)
        }
        return (tableWidth/3)
    }
}
