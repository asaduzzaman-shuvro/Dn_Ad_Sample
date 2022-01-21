//
//  GroupInfo.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 27/7/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

struct GroupInfo: Component {
    static let emptyValue = GroupInfo()

    enum GroupId: Equatable, Codable {
        case normal(String), dnEvents, cFlow, none
        
        static var defaultValue: GroupId {
            return .none
        }
        
        var isEmpty: Bool {
            return self == .none
        }
        
        static func getGroupId(from string: String) -> GroupId {
            switch string.lowercased() {
            case let id where id.contains("c-flow"):
                return .cFlow
            case "dn_events":
                return .dnEvents
            case "":
                return .none
            default:
                return .normal(string.lowercased())
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case .normal(let string):
                try? container.encode(string)
            case .cFlow:
                try? container.encode("c-flow")
            case .dnEvents:
                try? container.encode("dn_events")
            default:
                try? container.encode("")
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)
            
            switch stringValue.lowercased() {
            case let id where id.contains("c-flow"):
                self = .cFlow
            case "dn_events":
                self = .dnEvents
            case "":
                self = .none
            default:
                self = .normal(stringValue.lowercased())
            }
        }
        
        static func == (lhs: GroupId, rhs: GroupId) -> Bool {
            switch (lhs, rhs) {
            case (.normal(let groupIdString1), .normal(let groupIdString2)):
                return groupIdString1 == groupIdString2
            case (.dnEvents, .dnEvents), (.cFlow, .cFlow), (.none, .none):
                return true
            default:
                return false
            }
        }
    }
    
    private(set) var groupId: GroupId = .defaultValue
    private(set) var skin: String = ""
    private(set) var title: String = ""
    
    var isEmpty: Bool {
        return self.groupId.isEmpty
    }
    
    init() {
        self.init(groupId: .none, skin: "", title: "")
    }
        
    init(groupId: GroupId, skin: String, title: String ) {
        self.groupId = groupId
        self.skin = skin
        self.title = title
    }
}

// MARK: - Equatable
extension GroupInfo: Equatable {
    static func == (lhs: GroupInfo, rhs: GroupInfo) -> Bool {
        return lhs.groupId == rhs.groupId
    }
}

// MARK: - Codable
extension GroupInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case groupIDKey = "group_id"
        case skinKey = "skin"
        case titleKey = "title"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.groupId, forKey: .groupIDKey)
        try? container.encode(self.skin, forKey: .skinKey)
        try? container.encode(self.title, forKey: .titleKey)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? self.groupId = container.decode(GroupId.self, forKey: .groupIDKey)
        try? self.skin = container.decode(String.self, forKey: .skinKey)
        try? self.title = container.decode(String.self, forKey: .titleKey)
    }
}
