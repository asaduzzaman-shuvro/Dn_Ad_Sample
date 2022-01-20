//
//  AnyCollectionViewFeedPartBuilder.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 28/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class AnyCollectionViewFeedPartBuilder<SectionType>: CollectionViewFeedPartBuilderType {
    private let pageTypeClosure: () -> PageType
    private let getFeedMappingContextClosure: () -> FeedMappingContextType
    private let getInitialsClosure: (SectionType, UICollectionView.ScrollDirection) -> CollectionViewSectionLayoutInitialsDefinerType
    private let getSectionTypeClosure: (Component) -> SectionType
    private let isSectionTypeEqualClosure: (SectionType, SectionType) -> Bool
    private let buildUpPartClosure: (Component, Bool, Bool, FeedMappingContextType) -> CollectionViewFeedPart
    private let headerPartClouser: (SectionType) -> CollectionViewFeedPart?
    
    init<PartBuilder: CollectionViewFeedPartBuilderType> (partBuilder: PartBuilder) where PartBuilder.SectionType == SectionType {
        self.pageTypeClosure = { return partBuilder.pageType }
        self.getFeedMappingContextClosure = partBuilder.getFeedMappingContext
        self.getInitialsClosure = partBuilder.getInitials
        self.getSectionTypeClosure = partBuilder.getSectionType
        self.isSectionTypeEqualClosure = partBuilder.isSectionTypeEqual
        self.buildUpPartClosure = partBuilder.buildUpPart
        self.headerPartClouser = partBuilder.buildHeaderPart
    }
    
    var pageType: PageType {
        return self.pageTypeClosure()
    }
    
    func getFeedMappingContext() -> FeedMappingContextType {
        return self.getFeedMappingContextClosure()
    }
    
    func getInitials(section: SectionType, scrollDirection: UICollectionView.ScrollDirection) -> CollectionViewSectionLayoutInitialsDefinerType {
        return self.getInitialsClosure(section, scrollDirection)
    }
    
    func getSectionType(for component: Component) -> SectionType {
        return self.getSectionTypeClosure(component)
    }
    
    func isSectionTypeEqual(lhs: SectionType, rhs: SectionType) -> Bool {
        return self.isSectionTypeEqualClosure(lhs, rhs)
    }
    
    func buildUpPart(for component: Component, isFirstComponentInSection firstComponentFlag: Bool, isLastComponentInSection lastComponentFlag: Bool, context: FeedMappingContextType) -> CollectionViewFeedPart {
        return self.buildUpPartClosure(component, firstComponentFlag, lastComponentFlag, context)
    }
    
    func buildHeaderPart(forSection section: SectionType) -> CollectionViewFeedPart? {
        return self.headerPartClouser(section)
    }
    
}
