//
//  ArticleSummaryPagePartBuilderType+ArticleSummaryParts.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 5/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum ArticleSummaryTextPositioning {
    case centerVerticallyHorizontally, normal
}

extension ArticleSummaryPagePartBuilderType {
    func buildUpDFPAdPart(adComponent: DFPAd, isResizable: Bool, isRemovable: Bool, size: CGSize, context: FeedMappingContextType) -> CollectionViewFeedPart {
        let part = DFPAdPart.Builder().set(adAlias: adComponent.adUnitId)
            .set(isRemovable: isRemovable)
            .set(isResizable: isResizable)
            .set(loadedAdSize: adComponent.adSize)
            .set(size: size).build()
        
        part.delegate = self.adComponentDelegate
        return part
    }
}

