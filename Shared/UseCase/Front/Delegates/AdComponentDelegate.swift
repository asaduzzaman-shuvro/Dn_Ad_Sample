//
//  AdComponentDelegate.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 15/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import GoogleMobileAds

protocol AdComponentDelegate: DynamicContentCellDelegate {
    func getRootViewController() -> UIViewController?
    func cacheAdView(adViewIdentifier: String, bannerView: GADBannerView, adFailed: Bool)
    func fetchAdView(adViewIdentifier: String) -> DFPAdView?
}
