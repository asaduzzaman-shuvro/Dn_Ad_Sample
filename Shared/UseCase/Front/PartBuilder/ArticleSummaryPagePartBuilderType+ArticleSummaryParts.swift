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
    
    func buildArticleSummaryPart(for articleSummary: ArticleSummary,  inContext context: FeedMappingContextType) -> ArticleSummaryPart {
        
        let size = CGSize(width: context.contentWidth, height: 200)
        
        return ArticleSummaryPart(articleSummary: articleSummary, image: nil, badge: nil, authorImage: nil, kicker: nil, title: AttributedTextPartFragment(attributedString: NSAttributedString(string: articleSummary.title), size: CGSize(width: size.width, height: 60), margins: Margins(top: 10, bottom: 10, left: 0, right: 0), backgroundColor: UIColor.white), leadText: nil, isVideoArticle: false, size: size, cellNibName: "ArticleSummaryNormalCell", cellReuseId: "ArticleSummaryNormalCellReuseId", backgroundColor: .white, topRounding: false, bottomRounding: false)
        
    }
}

