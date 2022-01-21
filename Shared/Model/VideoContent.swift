//
//  VideoContent.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 16/4/19.
//  Copyright © 2019 no.dn.dn. All rights reserved.
//

import Foundation

class VideoContent: Component, Codable {
    static let emptyVideo = VideoContent()
    
    private(set) var type: String = ""
    private(set) var image: ImageWithRepresentations = .emptyImageWithRepresentations
    private(set) var provider: String = ""
    private(set) var title: String = ""
    private(set) var jwPlayerID: String?
    private(set) var otherPlayerID: String?
    
    var videoID: String {
        return (self.provider == "jwplayer" ? self.jwPlayerID : otherPlayerID) ?? ""
    }
    
    var isEmpty: Bool {
        return self.provider.isEmpty
    }
    
    init(type: String = "", image: ImageWithRepresentations = .emptyImageWithRepresentations, provider: String = "", title: String = "", jwPlayerID: String? = nil, otherPlayerID: String? = nil) {
        self.type = type
        self.image = image
        self.provider = provider
        self.title = title
        self.jwPlayerID = jwPlayerID
        self.otherPlayerID = otherPlayerID
    }
    
    enum CodingKeys: String, CodingKey {
        case typeKey = "type"
        case imageKey = "image"
        case providerKey = "provider"
        case titleKey = "title"
        case otherPlayerIDKey = "id"
        case jwPlayerIDKey = "jw_player_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.type, forKey: .typeKey)
        try? container.encode(self.image, forKey: .imageKey)
        try? container.encode(self.provider, forKey: .providerKey)
        try? container.encode(self.title, forKey: .titleKey)
        try? container.encodeIfPresent(self.jwPlayerID, forKey: .jwPlayerIDKey)
        try? container.encodeIfPresent(self.otherPlayerID, forKey: .otherPlayerIDKey)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? self.type = container.decode(String.self, forKey: .typeKey)
        try? self.image = container.decode(ImageWithRepresentations.self, forKey: .imageKey)
        try? self.provider = container.decode(String.self, forKey: .providerKey)
        try? self.title = container.decode(String.self, forKey: .titleKey)
        try? self.jwPlayerID = container.decodeIfPresent(String.self, forKey: .jwPlayerIDKey)
        try? self.otherPlayerID = container.decodeIfPresent(String.self, forKey: .otherPlayerIDKey)
    }
}
