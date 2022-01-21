//
//  ArticleSummaryType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 10/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

protocol ArticleSummaryType: Component {
    var publishedAt: Date { get }
    var updatedAt: Date { get }
    
    var id: String { get }
    
    var layout: ArticleStyle { get }
    var priority: Priority? { get }
    var skin: Skin? { get }
    var background: Background { get }
    var viewType: ViewType { get }
    
    var plusContent: Bool { get }
    var openExternally: Bool { get }
    var publicUrl: String { get }
    
    var image: ImageWithRepresentations { get }
    var badge: String { get }
    var relatedVideoContent: VideoContent { get }
    
    var author: Author { get }
    var kicker: String { get }
    var title: String { get }
    var leadText: String { get }
    
    var header: ArticleSummaryHeader { get }
    
    var hasImage: Bool { get }
    
    var groupInfo: GroupInfo {get}
    var doesBelongToGroup: Bool {get}
    
    var hasBookmarkSection: Bool { get }
}
