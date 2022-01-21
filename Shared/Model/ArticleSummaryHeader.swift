//
//  ArticleSummaryHeader.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 14/12/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

class ArticleSummaryHeader: Component, Codable {
    static let emptyHeader = ArticleSummaryHeader(name: "", linkTag: "", fromExternalSource: false)
    
    private(set) var name: String = ""
    private(set) var linkTag: String = ""
    private(set) var fromExternalSource: Bool = false
    
    var isEmpty: Bool {
        return self.name.isEmpty || self.linkTag.isEmpty
    }
    
    init(name: String, linkTag: String, fromExternalSource: Bool) {
        self.name = name
        self.linkTag = linkTag
        self.fromExternalSource = fromExternalSource
    }
    
    enum CodingKeys: String, CodingKey {
        case htmlTextKey = "html_text"
        case idKey = "id"
        case fromExternalSourceKey = "external_source"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.name, forKey: .htmlTextKey)
        try? container.encode(self.linkTag, forKey: .idKey)
        try? container.encode(self.fromExternalSource, forKey: .fromExternalSourceKey)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? self.name = container.decode(String.self, forKey: .htmlTextKey)
        try? self.linkTag = container.decode(String.self, forKey: .idKey)
        try? self.fromExternalSource = container.decode(Bool.self, forKey: .fromExternalSourceKey)
    }
}
