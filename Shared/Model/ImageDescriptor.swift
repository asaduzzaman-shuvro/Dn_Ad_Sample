//
// Created by Apps AS on 22/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

class ImageDescriptor: Codable {

    static let emptyDescriptor = ImageDescriptor(size: CGSize.zero, urlString: "")

    private(set) var size: CGSize = .zero
    private(set) var urlString: String = ""

    init(size: CGSize, urlString:String) {
        self.size = size
        self.urlString = urlString
    }
    
    //MARK:- Decodable
    enum CodingKeys: String, CodingKey {
        case sizeKey = "size"
        case urlStringKey = "url"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.size.toAPIModel(), forKey: .sizeKey)
        try? container.encode(self.urlString, forKey: .urlStringKey)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? size = container.decode(CGSize.APIModel.self, forKey: .sizeKey).toCGSize()
        try? urlString = container.decode(String.self, forKey: .urlStringKey)
    }
}
