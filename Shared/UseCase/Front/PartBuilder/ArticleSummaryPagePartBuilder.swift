//
//  ArticleSummaryPagePartBuilder.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 5/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class ArticleSummaryPagePartBuilder: ArticleSummaryPagePartBuilderType {
    
    typealias SectionType = FrontArticleSummarySection
    
    weak var adComponentDelegate: AdComponentDelegate?
    weak var webContentViewCellDelegate: WebContentViewCellDelegate?
    
    let pageType: PageType
    
    let viewInitialsFactory: ArticleSummaryPageViewInitialsFactory
    
    weak var swipeSectionFeedJSONResolver: FeedJSONResolver?
    weak var swipeSectionPartBuilder: AnyArticleSummaryPagePartBuilder<FrontArticleSummarySection>?
    
    init(pageType: PageType, viewInitialsFactory: ArticleSummaryPageViewInitialsFactory) {
        self.pageType = pageType
        self.viewInitialsFactory = viewInitialsFactory
    }
    
    func getFeedJSONResolverForSwipeSection() -> FeedJSONResolver? {
        return self.swipeSectionFeedJSONResolver
    }
    
    func getPartBuilderForSwipeSection() -> AnyArticleSummaryPagePartBuilder<FrontArticleSummarySection>? {
        return self.swipeSectionPartBuilder
    }
    
    func getFeedMappingContext() -> FeedMappingContextType {
        return CollectionViewFeedMappingContext(previousPart: .top, backgroundColor: .clear, contentWidth: .zero, disableTopRounding: true, disableBottomRounding: true)
    }
    
    func getInitials(section: FrontArticleSummarySection, scrollDirection: UICollectionView.ScrollDirection) -> CollectionViewSectionLayoutInitialsDefinerType {
        return self.viewInitialsFactory.getInitials(pageType: pageType, section: section, scrollDirection: scrollDirection)
    }
    
    func getSectionType(for component: Component) -> FrontArticleSummarySection {
        switch Mirror(reflecting: component).subjectType {
        default:
            return .nonSwipeableSection
        }
    }
    
    func buildHeaderPart(forSection section: FrontArticleSummarySection) -> CollectionViewFeedPart? {
       return nil
    }
    
    func isSectionTypeEqual(lhs: FrontArticleSummarySection, rhs: FrontArticleSummarySection) -> Bool {
       return lhs == rhs
    }
    
    
    func buildUpPart(for component: Component, isFirstComponentInSection firstComponentFlag: Bool, isLastComponentInSection lastComponentFlag: Bool, context: FeedMappingContextType) -> CollectionViewFeedPart {
        switch component {
        case let ad as DFPAd:
            let partSize = CGSize(width: context.contentWidth, height: ad.adSize.height)
            return self.buildUpDFPAdPart(adComponent: ad, isResizable: true, isRemovable: true, size: partSize, context: context)
        default:
            return UnknownPart(component: component)
        }
    }
}
