//
//  DFPAdManager.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 5/3/19.
//  Copyright © 2019 no.dn.dn. All rights reserved.
//

import Foundation
import GoogleMobileAds

class DFPAdManager{
    static let sharedInstance = DFPAdManager()
    
    var adViews: [String: DFPAdView] = [String: DFPAdView] ()
    
    private init(){}
    
    func cacheView(adViewIdentifier: String, dfpBannerView: GADBannerView, adFailed: Bool) {
        guard !adViews.keys.contains(adViewIdentifier) else{
            return
        }
        
        let adView = DFPAdView(adBannerView: dfpBannerView, adFailed: adFailed)
        adViews[adViewIdentifier] = adView
    }
    
    func fetchView(adViewIdentifier: String) -> DFPAdView? {
        if adViews.keys.contains(adViewIdentifier) {
            return adViews[adViewIdentifier]
        }
        return nil
    }
    
    func clear() {
        adViews.removeAll()
    }
}
