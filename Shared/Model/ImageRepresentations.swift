//
//  ImageRepresentations.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 14/7/21.
//  Copyright © 2021 no.dn.dn. All rights reserved.
//

import Foundation

struct ImageRepresentations: Component {
    static let emptyImageRepresentations = ImageRepresentations()
    
    private(set) var square: String = ""
    private(set) var landscape: String = ""
    private(set) var portrait: String = ""
    private(set) var portraitWide: String = ""
    
    var isEmpty: Bool {
        return self.square.isEmpty || self.landscape.isEmpty || self.portrait.isEmpty || self.portraitWide.isEmpty
    }
    
    func getRepresentation(for key: ImageRepresentations.CodingKeys) -> String {
        switch key {
        case .square:
            return self.square
        case .landscape:
            return self.landscape
        case .portrait:
            return self.portrait
        case .portraitWide:
            return self.portraitWide
        }
    }
}

// MARK: - Codable
extension ImageRepresentations: Codable {
    enum CodingKeys: String, CodingKey {
        case square = "square_representation"
        case landscape = "landscape_representation"
        case portrait = "portrait_representation"
        case portraitWide = "portrait_wide_representation"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.square, forKey: .square)
        try? container.encode(self.landscape, forKey: .landscape)
        try? container.encode(self.portrait, forKey: .portrait)
        try? container.encode(self.portraitWide, forKey: .portraitWide)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try? square = container.decode(String.self, forKey: .square)
        try? landscape = container.decode(String.self, forKey: .landscape)
        try? portrait = container.decode(String.self, forKey: .portrait)
        try? portraitWide = container.decode(String.self, forKey: .portraitWide)
    }
}
