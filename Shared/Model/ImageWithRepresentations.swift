//
//  ImageWithRepresentations.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 30/11/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

class ImageWithRepresentations: Component, Codable {
    static let emptyImageWithRepresentations = ImageWithRepresentations(photographer: .emptyPhotographer, caption: "", alignment: "", descriptors: [], representations: ImageRepresentations.emptyImageRepresentations)
    
    private(set) var photographer: Photographer = .emptyPhotographer
    private(set) var caption: String = ""
    private(set) var alignment: String = ""
    private(set) var descriptors: [ImageDescriptor] = []
    private(set) var representations: ImageRepresentations = .emptyImageRepresentations
    
    var isEmpty: Bool {
        return self.descriptors.isEmpty || self.representations.isEmpty
    }
    
    init(photographer: Photographer, caption: String, alignment: String, descriptors: [ImageDescriptor], representations: ImageRepresentations) {
        self.photographer = photographer
        self.caption = caption
        self.alignment = alignment
        self.descriptors = descriptors
        self.representations = representations
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case photgrapherKey = "photographer"
        case captionKey = "caption"
        case alignmentKey = "alignment"
        case descriptorsKey = "files"
        case representationKey = "representation"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.photographer, forKey: .photgrapherKey)
        try? container.encode(self.caption, forKey: .captionKey)
        try? container.encode(self.alignment, forKey: .alignmentKey)
        try? container.encode(self.descriptors, forKey: .descriptorsKey)
        try? container.encode(self.representations, forKey: .representationKey)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? photographer =  container.decode(Photographer.self, forKey: .photgrapherKey)
        try? caption = container.decode(String.self, forKey: .captionKey)
        try? alignment = container.decode(String.self, forKey: .alignmentKey)
        try? descriptors = container.decode([ImageDescriptor].self, forKey: .descriptorsKey)
        try? representations = container.decode(ImageRepresentations.self, forKey: .representationKey)
    }
}
