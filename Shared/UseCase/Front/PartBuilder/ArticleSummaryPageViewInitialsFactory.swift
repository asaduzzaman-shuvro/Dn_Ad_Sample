//
//  ArticleSummaryPageViewInitialsFactory.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 4/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit

enum FrontArticleSummarySection {
    case pageHeader
    case swipeableSection
    case nonSwipeableSection
    case inlineFeedSection
    case hotTopicsBar
    case minSmakCarouselSection
}

extension FrontArticleSummarySection: Equatable {
    static func == (lhs: FrontArticleSummarySection, rhs: FrontArticleSummarySection) -> Bool {
        switch (lhs, rhs) {
        case (.pageHeader, .pageHeader), (.swipeableSection, .swipeableSection), (.nonSwipeableSection, .nonSwipeableSection), (.inlineFeedSection, .inlineFeedSection), (.hotTopicsBar, .hotTopicsBar):
            return true
        default:
            return false
        }
    }
}

final class ArticleSummaryPageViewInitialsFactory {
    fileprivate var swipeableSectionInitials: CollectionViewSectionLayoutInitialsDefinerType {
        let cellInitials = CollectionViewCellLayoutInitials.CVCellLayoutInitialsBuilder()
            .setExpectedItemWidth(FeedAppearanceProvider.sharedInstance.feedWidth)
            .setExpectedNoOfItemsInRow(1)
            .setLineSpacing(16)
            .setMinimumInterItemSpacing(16).build()

        let sectionInitials = CollectionViewSectionLayoutInitials.CVSectionLayoutInitialsBuilder()
            .setSectionInset(UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero))
            .setCellLayoutInitialsDefiner(cellInitials)
            .setIsSameHeightCell(true).build()

        return sectionInitials
    }

    fileprivate func getNonSwipeableSectionInset(for pageType: PageType) -> UIEdgeInsets {
        switch pageType {
        case .sisteNytt:
            return UIEdgeInsets(top: 20, left: 8, bottom: .zero, right: 8)
        case .search, .topic, .bookmarkArticle:
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        case .smakSearch:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        default:
            return .zero
        }
    }

    fileprivate func getNonSwipeableItemLineSpacing(for pageType: PageType) -> CGFloat {
        switch pageType {
        case .sisteNytt:
            return 5
        case .search, .favoriteArticle:
            return 15
        case .smakSearch:
            return 8
        default:
            return 10
        }
    }

    fileprivate func getNonSwipeableSectionInitials(lineSpacing: CGFloat, sectionInset: UIEdgeInsets) -> CollectionViewSectionLayoutInitialsDefinerType {
        let cellInitials = CollectionViewCellLayoutInitials.CVCellLayoutInitialsBuilder()
            .setExpectedItemWidth(FeedAppearanceProvider.sharedInstance.feedWidth)
            .setExpectedNoOfItemsInRow(1)
            .setLineSpacing(lineSpacing).build()

        let sectionInitials = CollectionViewSectionLayoutInitials.CVSectionLayoutInitialsBuilder().setCellLayoutInitialsDefiner(cellInitials).setSectionInset(sectionInset)
            .setIsSameHeightCell(false).build()

        return sectionInitials
    }

    fileprivate var pageHeaderInitials : CollectionViewSectionLayoutInitialsDefinerType {
        let cellInitials = CollectionViewCellLayoutInitials.CVCellLayoutInitialsBuilder()
            .setExpectedItemWidth(FeedAppearanceProvider.sharedInstance.feedWidth)
            .setExpectedNoOfItemsInRow(1)
            .setLineSpacing(.zero).build()

        let sectionInitials = CollectionViewSectionLayoutInitials.CVSectionLayoutInitialsBuilder()
            .setCellLayoutInitialsDefiner(cellInitials)
            .setSectionInset(.zero)
            .setIsSameHeightCell(true).build()

        return sectionInitials
    }


    fileprivate var inlineFeedSectionInitials: CollectionViewSectionLayoutInitialsDefinerType {
        let cellInitials = CollectionViewCellLayoutInitials.CVCellLayoutInitialsBuilder()
            .setExpectedItemWidth(FeedAppearanceProvider.sharedInstance.feedWidth)
            .setExpectedNoOfItemsInRow(1)
            .setLineSpacing(16)
            .setMinimumInterItemSpacing(16).build()

        let sectionInitials = CollectionViewSectionLayoutInitials.CVSectionLayoutInitialsBuilder()
            .setSectionInset(UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero))
            .setCellLayoutInitialsDefiner(cellInitials)
            .setIsSameHeightCell(false).build()

        return sectionInitials
    }


    fileprivate var hotTopicsBarSectionInitials: CollectionViewSectionLayoutInitialsDefinerType {
        let cellInitials = CollectionViewCellLayoutInitials.CVCellLayoutInitialsBuilder()
            .setExpectedItemWidth(FeedAppearanceProvider.sharedInstance.feedWidth)
            .setExpectedNoOfItemsInRow(1)
            .setLineSpacing(.zero)
            .setMinimumInterItemSpacing(.zero).build()

        let sectionInitials = CollectionViewSectionLayoutInitials.CVSectionLayoutInitialsBuilder()
            .setSectionInset(UIEdgeInsets.zero)
            .setCellLayoutInitialsDefiner(cellInitials)
            .setIsSameHeightCell(true).build()

        return sectionInitials
    }

    func getInitials(pageType: PageType, section: FrontArticleSummarySection, scrollDirection: UICollectionView.ScrollDirection) -> CollectionViewSectionLayoutInitialsDefinerType {
        switch section {
        case .swipeableSection:
            return self.swipeableSectionInitials
        case .pageHeader:
            return self.pageHeaderInitials
        case .inlineFeedSection:
            return self.inlineFeedSectionInitials
        case .hotTopicsBar:
            return self.hotTopicsBarSectionInitials
        default:
            let lineSpacing = self.getNonSwipeableItemLineSpacing(for: pageType)
            let sectionInset = self.getNonSwipeableSectionInset(for: pageType)
            return self.getNonSwipeableSectionInitials(lineSpacing: lineSpacing, sectionInset: sectionInset)
        }
    }
}
