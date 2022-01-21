//
//  Author.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 15/7/21.
//  Copyright © 2021 no.dn.dn. All rights reserved.
//

import Foundation

struct Author: Component {
    static let emptyAuthor = Author()
    
    private(set) var name: String = ""
    private(set) var title: String = ""
    private(set) var image: ImageWithRepresentations = .emptyImageWithRepresentations
    
    var isEmpty: Bool {
        return self.name.isEmpty || self.image.descriptors.isEmpty
    }
}

// MARK: - Codable
extension Author: Codable {
    enum CodingKeys: String, CodingKey {
        case nameKey = "name"
        case titleKey = "title"
        case imageKey = "image"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.name, forKey: .nameKey)
        try? container.encode(self.title, forKey: .titleKey)
        try? container.encode(self.image, forKey: .imageKey)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? self.name = container.decode(String.self, forKey: .nameKey)
        try? self.title = container.decode(String.self, forKey: .titleKey)
        try? self.image = container.decode(ImageWithRepresentations.self, forKey: .imageKey)
    }
}
