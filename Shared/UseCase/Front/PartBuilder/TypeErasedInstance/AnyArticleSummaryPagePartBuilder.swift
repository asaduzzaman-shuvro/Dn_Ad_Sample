//
//  AnyArticleSummaryPagePartBuilder.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 4/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class AnyArticleSummaryPagePartBuilder<SectionType>: ArticleSummaryPagePartBuilderType {
    private let collectionViewPartBuilder: AnyCollectionViewFeedPartBuilder<SectionType>
//    private let favoriteArticleSwipeSectionDelegateGetterClosure: () -> SwipeSectionDelegate?
//    private let favoriteArticleSwipeSectionDelegateSetterClosure: (SwipeSectionDelegate?) -> Void
    private let adComponentDelegateGetterClosure: () -> AdComponentDelegate?
    private let adComponentDelegateSetterClosure: (AdComponentDelegate?) -> Void
//    private let bookmarkSectionDelegateGetterClosure: () -> BookmarkSectionDelegate?
//    private let bookmarkSectionDelegateSetterClosure: (BookmarkSectionDelegate?) -> Void
    private let webContentViewCellDelegateGetterClosure: () -> WebContentViewCellDelegate?
    private let webContentViewCellDelegateSetterClosure: (WebContentViewCellDelegate?) -> Void
//    private let showMoreCellDelegateGetterClosure: () -> ShowMoreCellDelegate?
//    private let showMoreCellDelegateSetterClosure: (ShowMoreCellDelegate?) -> Void
//    private let videoCellDelegateGetterClosure: () -> VideoCellDelegate?
//    private let videoCellDelegateSetterClosure: (VideoCellDelegate?) -> Void
//
//    private let hotTopicsCellDelegateGetterClosure: () -> HotTopicCellDelagate?
//    private let hotTopicsCellDelegateSetterClosure: (HotTopicCellDelagate?) -> Void
    
    init<PartBuilder: ArticleSummaryPagePartBuilderType>(partBuilder: PartBuilder) where PartBuilder.SectionType == SectionType {
        self.collectionViewPartBuilder = AnyCollectionViewFeedPartBuilder<SectionType>(partBuilder: partBuilder)
//        self.favoriteArticleSwipeSectionDelegateGetterClosure = {
//            return partBuilder.swipeSectionDelegate
//        }
//        self.favoriteArticleSwipeSectionDelegateSetterClosure = { favoriteArticleSwipeSectionDelegate in
//            partBuilder.swipeSectionDelegate = favoriteArticleSwipeSectionDelegate
//        }
        
        self.adComponentDelegateGetterClosure = {
            return partBuilder.adComponentDelegate
        }
        self.adComponentDelegateSetterClosure = { adComponentDelegate in
            partBuilder.adComponentDelegate = adComponentDelegate
        }
        
//        self.bookmarkSectionDelegateGetterClosure = {
//            return partBuilder.articleSummaryBookmarkSectionDelegate
//        }
//        self.bookmarkSectionDelegateSetterClosure = { bookmarkSectionDelegate in
//            partBuilder.articleSummaryBookmarkSectionDelegate = bookmarkSectionDelegate
//        }
        
        self.webContentViewCellDelegateGetterClosure = {
            return partBuilder.webContentViewCellDelegate
        }
        self.webContentViewCellDelegateSetterClosure = { webContentViewCellDelegate in
            partBuilder.webContentViewCellDelegate = webContentViewCellDelegate
        }
        
//        self.showMoreCellDelegateGetterClosure = {
//            return partBuilder.showMoreCellDelegate
//        }
//        self.showMoreCellDelegateSetterClosure = { showMoreCellDelegate in
//            partBuilder.showMoreCellDelegate = showMoreCellDelegate
//        }
//
//        self.videoCellDelegateGetterClosure = {
//            return partBuilder.videoCellDelegate
//        }
//        self.videoCellDelegateSetterClosure = { videoCellDelegate in
//            partBuilder.videoCellDelegate = videoCellDelegate
//        }
//
//        self.hotTopicsCellDelegateGetterClosure = {
//            return partBuilder.hotTopicCellDelegate
//        }
//
//        self.hotTopicsCellDelegateSetterClosure = { hotTopicsDelegate in
//            partBuilder.hotTopicCellDelegate = hotTopicsDelegate
//        }

    }
    
    var pageType: PageType {
        return self.collectionViewPartBuilder.pageType
    }
    
//    var swipeSectionDelegate: SwipeSectionDelegate? {
//        get {
//            return self.favoriteArticleSwipeSectionDelegateGetterClosure()
//        }set(newValue) {
//            self.favoriteArticleSwipeSectionDelegateSetterClosure(newValue)
//        }
//    }
//
//    var articleSummaryBookmarkSectionDelegate: BookmarkSectionDelegate? {
//        get {
//            return self.bookmarkSectionDelegateGetterClosure()
//        }set(newValue) {
//            self.bookmarkSectionDelegateSetterClosure(newValue)
//        }
//    }
//
    var adComponentDelegate: AdComponentDelegate? {
        get {
            return self.adComponentDelegateGetterClosure()
        }set(newValue) {
            self.adComponentDelegateSetterClosure(newValue)
        }
    }
    
    var webContentViewCellDelegate: WebContentViewCellDelegate? {
        get {
            return self.webContentViewCellDelegateGetterClosure()
        }set(newValue) {
            return self.webContentViewCellDelegateSetterClosure(newValue)
        }
    }
//
//    var showMoreCellDelegate: ShowMoreCellDelegate? {
//        get {
//            return self.showMoreCellDelegateGetterClosure()
//        }set(newValue) {
//            self.showMoreCellDelegateSetterClosure(newValue)
//        }
//    }
//
//    var videoCellDelegate: VideoCellDelegate? {
//        get {
//            return self.videoCellDelegateGetterClosure()
//        }set(newValue) {
//            return self.videoCellDelegateSetterClosure(newValue)
//        }
//    }
//
//    var hotTopicCellDelegate: HotTopicCellDelagate? {
//        get {
//            return self.hotTopicsCellDelegateGetterClosure()
//        }
//        set {
//            self.hotTopicsCellDelegateSetterClosure(newValue)
//        }
//    }
        
    func buildUpPart(for component: Component, isFirstComponentInSection firstComponentFlag: Bool, isLastComponentInSection lastComponentFlag: Bool, context: FeedMappingContextType) -> CollectionViewFeedPart {
        return self.collectionViewPartBuilder.buildUpPart(for: component, isFirstComponentInSection: firstComponentFlag, isLastComponentInSection: lastComponentFlag, context: context)
    }

    func getFeedMappingContext() -> FeedMappingContextType {
        return self.collectionViewPartBuilder.getFeedMappingContext()
    }
    
    func getInitials(section: SectionType, scrollDirection: UICollectionView.ScrollDirection) -> CollectionViewSectionLayoutInitialsDefinerType {
        return self.collectionViewPartBuilder.getInitials(section: section, scrollDirection: scrollDirection)
    }
    
    func buildHeaderPart(forSection section: SectionType) -> CollectionViewFeedPart? {
        return self.collectionViewPartBuilder.buildHeaderPart(forSection: section)
    }
    
    func getSectionType(for component: Component) -> SectionType {
        return self.collectionViewPartBuilder.getSectionType(for: component)
    }
    
    func isSectionTypeEqual(lhs: SectionType, rhs: SectionType) -> Bool {
        return self.collectionViewPartBuilder.isSectionTypeEqual(lhs: lhs, rhs: rhs)
    }
}
