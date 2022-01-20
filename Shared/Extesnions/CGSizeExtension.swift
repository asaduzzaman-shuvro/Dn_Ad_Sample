//
//  CGSizeExtension.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 28/7/21.
//  Copyright © 2021 no.dn.dn. All rights reserved.
//

import UIKit

extension CGSize {
    struct APIModel {
        static let zero = APIModel()
        
        private(set) var width: CGFloat = .zero
        private(set) var height: CGFloat = .zero
    }
}

extension CGSize.APIModel: Codable {
    enum CodingKeys: String, CodingKey {
        case widthKey = "width"
        case heightKey = "height"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.width, forKey: .widthKey)
        try? container.encode(self.height, forKey: .heightKey)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? width = container.decode(CGFloat.self, forKey: .widthKey)
        try? height = container.decode(CGFloat.self, forKey: .heightKey)
    }
}

extension CGSize.APIModel {
    func toCGSize() -> CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}

extension CGSize {
    func toAPIModel() -> APIModel {
        return APIModel(width: self.width, height: self.height)
    }
}
