//
// Created by Apps AS on 09/05/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

class FeedAppearanceProviderFactory {

    class func createFeedSizeProvider() -> FeedAppearanceProviding {
        let screenWidth = UIScreen.main.bounds.width

        if UIDevice.current.userInterfaceIdiom == .phone {
            return FeedAppearanceProvideriPhone()
        }else{
            if screenWidth >= 1024 {
                return FeedAppearanceProvideriPadPro()
            }
            else{
                return FeedAppearanceProvideriPad()
            }
        }
    }
}
