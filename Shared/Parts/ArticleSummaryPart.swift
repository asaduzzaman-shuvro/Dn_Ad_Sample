//
//  ArticleSummaryPart.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 3/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class ArticleSummaryPart: CollectionViewFeedPart {
    let articleId: String
    let image: ImagePartFragment?
    let badge: BadgePartFragment?
    let authorImage: ImagePartFragment?
    let kicker: AttributedTextPartFragment?
    let title: AttributedTextPartFragment?
    let leadText: AttributedTextPartFragment?
//    let bookmarkSection: BookmarkSectionPartFragment?
    
    let isVideoArticle: Bool
    var shouldShowFullWidthBadge: Bool = false
    
    init(articleId: String, image: ImagePartFragment?, badge: BadgePartFragment?, authorImage: ImagePartFragment?, kicker: AttributedTextPartFragment?, title: AttributedTextPartFragment?, leadText: AttributedTextPartFragment?, isVideoArticle: Bool, size: CGSize, cellNibName: String, cellReuseId: String, backgroundColor: UIColor, topRounding: Bool, bottomRounding: Bool) {
        self.articleId = articleId
        self.image = image
        self.badge = badge
        self.authorImage = authorImage
        self.kicker = kicker
        self.title = title
        self.leadText = leadText
        
        self.isVideoArticle = isVideoArticle
        
        super.init()
        
        self.size = size
        self.cellNibName = cellNibName
        self.cellReuseId = cellReuseId
        self.backgroundColor = backgroundColor
        self.topRounding = topRounding
        self.bottomRounding = bottomRounding
    }

}
