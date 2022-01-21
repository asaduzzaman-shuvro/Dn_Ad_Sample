//
//  Photographer.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 14/7/21.
//  Copyright © 2021 no.dn.dn. All rights reserved.
//

import Foundation

struct Photographer {
    
    static var emptyPhotographer: Photographer = Photographer()
    
    private(set) var name: String = ""
}

// MARK: - Codable
extension Photographer: Codable {
    enum CodingKeys: String, CodingKey {
        case nameKey = "name"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.name, forKey: .nameKey)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? name = container.decode(String.self, forKey: .nameKey)
    }
}
