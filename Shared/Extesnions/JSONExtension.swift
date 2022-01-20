//
//  JSONExtension.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 23/3/21.
//  Copyright © 2021 no.dn.dn. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: - Decodable
extension JSON {
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        guard let data = try? self.rawData(), !data.isEmpty else {
            throw JSONParsingError(message: "Can't parse")
        }
        
        do {
            let model = try JSONDecoder().decode(type, from: data)
            return model
        } catch {
            throw JSONParsingError(message: "Can't parse")
        }
    }
    
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        guard let data = try? rawData(), !data.isEmpty else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

//MARK: - Serialization Error
extension JSON {
    static func createJSONSerializationError() -> NSError {
        return NSError(domain: "Can't parse", code: -9999, userInfo: nil)
    }
}

extension JSON {
    func decode<T: Decodable & Component>(_ type: T.Type) -> Component {
        if let model = self.decode(type) {
            return model
        }
        
        return UnknownComponent(json: self)
    }
}
