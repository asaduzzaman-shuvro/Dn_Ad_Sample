//
// Created by Apps AS on 26/01/16.
// Copyright (c) 2016 All rights reserved.
//
// PURE DATA
// Represents an article on the news feed.

import Foundation

class ArticleSummary: ArticleSummaryType, Codable {
    static let emptyValue = ArticleSummary()

    private(set) var publishedAt: Date = Date()
    private(set) var updatedAt: Date = Date()
    
    private(set) var id: String = ""
    
    private(set) var layout: ArticleStyle = .defaultValue
    private(set) var priority: Priority?
    private(set) var skin: Skin?
    private(set) var background: Background = .defaultValue
    private(set) var viewType: ViewType = .defaultValue
    
    private(set) var plusContent: Bool = false
    private(set) var openExternally: Bool = false
    private(set) var publicUrl: String = ""
    
    private(set) var image: ImageWithRepresentations = .emptyImageWithRepresentations
    private(set) var badge: String = ""
    private(set) var relatedVideoContent: VideoContent = .emptyVideo
     
    private(set) var author: Author = .emptyAuthor
    
    private(set) var _kicker: String = ""
    var kicker: String {
        return self._kicker
    }
    
    private(set) var title: String = ""
    private(set) var leadText: String = ""
    
    private(set) var header: ArticleSummaryHeader = .emptyHeader
    
    private(set) var groupInfo: GroupInfo = .emptyValue
    
    var hasImage: Bool {
        return !self.relatedVideoContent.image.isEmpty || !self.image.isEmpty
    }
    
    var doesBelongToGroup: Bool {
        return !self.groupInfo.isEmpty
    }
    
    var hasBookmarkSection: Bool {
        return true
    }
    
    var isEmpty: Bool {
        return false
    }
    
    init() {}
    
    init(withId id: String, publicUrl: String, title: String, leadText: String) {
        self.id = id
        self.publicUrl = publicUrl
        self.title = title
        self.leadText = leadText
    }
    
    init(publishedAt: Date, updatedAt: Date, id: String, layout: ArticleStyle, priority: Priority?, skin: Skin?, background: Background, viewType: ViewType, plusContent: Bool, openExternally: Bool, publicUrl: String, image: ImageWithRepresentations, badge: String, relatedVideoContent: VideoContent, author: Author, kicker: String, title: String, leadText: String, header: ArticleSummaryHeader, group: GroupInfo = GroupInfo.emptyValue) {
        self.publishedAt = publishedAt
        self.updatedAt = updatedAt
        
        self.id = id
        
        self.layout = layout
        self.priority = priority
        self.skin = skin
        self.background = background
        self.viewType = viewType
        
        self.plusContent = plusContent
        self.openExternally = openExternally
        self.publicUrl = publicUrl
        
        self.image = image
        self.badge = badge
        self.relatedVideoContent = relatedVideoContent
        
        self.author = author
        self._kicker = kicker
        self.title = title
        self.leadText = leadText
        
        self.header = header
        
        self.groupInfo = group
    }
    
    enum CodingKeys: String, CodingKey {
        case publishedAtKey = "published_at"
        case updatedAtKey = "updated_at"
        case idKey = "id"
        case layoutKey = "layout"
        case priorityKey = "priority"
        case skinKey = "skin"
        case backgroundKey = "background"
        case viewTypeKey = "view_type"
        case plusContentKey = "paid"
        case openExternallyKey = "open_externally"
        case publicUrlKey = "public_link"
        case imageKey = "image"
        case badgeKey = "badge"
        case relatedVideoContentKey = "video"
        case authorKey = "author_info"
        case kickerKey = "kicker"
        case titleKey = "title"
        case leadTextKey = "lead_text"
        case headerKey = "header"
        case groupInfoKey = "group"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.publishedAt, forKey: .publishedAtKey)
        try? container.encode(self.updatedAt, forKey: .updatedAtKey)
        try? container.encode(self.id, forKey: .idKey)
        try? container.encode(self.layout, forKey: .layoutKey)
        try? container.encode(self.priority, forKey: .priorityKey)
        try? container.encode(self.skin, forKey: .skinKey)
        try? container.encode(self.background, forKey: .backgroundKey)
        try? container.encode(self.viewType, forKey: .viewTypeKey)
        try? container.encode(self.plusContent, forKey: .plusContentKey)
        try? container.encode(self.openExternally, forKey: .openExternallyKey)
        try? container.encode(self.publicUrl, forKey: .publicUrlKey)
        try? container.encode(self.image, forKey: .imageKey)
        try? container.encode(self.badge, forKey: .badgeKey)
        try? container.encode(self.relatedVideoContent, forKey: .relatedVideoContentKey)
        try? container.encode(self.author, forKey: .authorKey)
        try? container.encode(self._kicker, forKey: .kickerKey)
        try? container.encode(self.title, forKey: .titleKey)
        try? container.encode(self.leadText, forKey: .leadTextKey)
        try? container.encode(self.header, forKey: .headerKey)
        try? container.encode(self.groupInfo, forKey: .groupInfoKey)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? self.publishedAt = NewsDateFormatter.shared.format(serverTime: container.decode(String.self, forKey: .publishedAtKey))
        try? self.updatedAt = NewsDateFormatter.shared.format(serverTime: container.decode(String.self, forKey: .updatedAtKey))
        try? self.id = container.decode(String.self, forKey: .idKey)
        try? self.layout = container.decode(ArticleStyle.self, forKey: .layoutKey)
        try? self.priority = container.decodeIfPresent(Priority.self, forKey: .priorityKey)
        try? self.skin = container.decodeIfPresent(Skin.self, forKey: .skinKey)
        try? self.background = container.decode(Background.self, forKey: .backgroundKey)
        try? self.viewType = container.decode(ViewType.self, forKey: .viewTypeKey)
        try? self.plusContent = container.decode(Bool.self, forKey: .plusContentKey)
        try? self.openExternally = container.decode(Bool.self, forKey: .openExternallyKey)
        try? self.publicUrl = container.decode(String.self, forKey: .publicUrlKey)
        try? self.image = container.decode(ImageWithRepresentations.self, forKey: .imageKey)
        try? self.badge = container.decode(String.self, forKey: .badgeKey)
        try? self.relatedVideoContent = container.decode(VideoContent.self, forKey: .relatedVideoContentKey)
        try? self.author = container.decode(Author.self, forKey: .authorKey)
        try? self._kicker = container.decode(String.self, forKey: .kickerKey)
        try? self.title = container.decode(String.self, forKey: .titleKey)
        try? self.leadText = container.decode(String.self, forKey: .leadTextKey)
        try? self.header = container.decode(ArticleSummaryHeader.self, forKey: .headerKey)
        try? self.groupInfo = container.decode(GroupInfo.self, forKey: .groupInfoKey)
    }
}
