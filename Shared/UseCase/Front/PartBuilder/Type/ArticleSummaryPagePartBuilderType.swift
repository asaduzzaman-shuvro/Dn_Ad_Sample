//
//  ArticleSummaryPagePartBuilderType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 4/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

protocol ArticleSummaryPagePartBuilderType: CollectionViewFeedPartBuilderType {
//    var swipeSectionDelegate: SwipeSectionDelegate? { get set }
//    var articleSummaryBookmarkSectionDelegate: BookmarkSectionDelegate? {get set }
    var adComponentDelegate: AdComponentDelegate? { get set }
    var webContentViewCellDelegate: WebContentViewCellDelegate? { get set }
//    var showMoreCellDelegate: ShowMoreCellDelegate? { get set }
//    var videoCellDelegate: VideoCellDelegate? { get set }
//    var hotTopicCellDelegate: HotTopicCellDelagate?{get set}
}
