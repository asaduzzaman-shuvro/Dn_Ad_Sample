//
//  Data+Extension.swift
//  GoogleAdSample (iOS)
//
//  Created by Asaduzzaman Shuvro on 20/1/22.
//

import Foundation

extension Encodable {
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}

extension Data  {
    func deSerialize<T: Codable>() -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: self)
    }
    
    func deserialize<T: Decodable>() -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: self)
    }
}
