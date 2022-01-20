//
//  FeedMappingContextType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

enum CollectionViewPortion {
    case top, articleSummary, menuEntry, menuEntryHeader, menuEntrySubheader, menuEntryGrid, tabItem, favoriteItem, favoriteItemListHeader, FavoriteItemListFooter, horizontalSwipeSection, searchResultCount, showMore, dnEventsHeader, dnLiveVideo, inlineFeed, investorSummary, newsletterSummary, newsletterSignUp
}

protocol FeedMappingContextType {
    var previousPart: CollectionViewPortion { get }
    var backgroundColor: UIColor { get }
    var contentWidth: CGFloat { get }
    var disableTopRounding: Bool { get }
    var disableBottomRounding: Bool { get }
    
    func changePreviousPart(_ part: CollectionViewPortion)
    func changeContentWidth(width: CGFloat)
    func configureTopRounding(enable: Bool)
    func configureBottomRounding(enable: Bool)
}
