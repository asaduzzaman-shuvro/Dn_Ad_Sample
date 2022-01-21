//
// Created by Apps AS on 26/01/16.
// Copyright (c) 2016 All rights reserved.
//
// PURE DATA
// Represents an article style.


import Foundation

class ArticleStyle: Codable {
    
    static let defaultValue = ArticleStyle()
    
    enum Theme: String, Hashable, Codable {
        
        case `default` = "default"
        case commentary = "commentary"
        case feature = "feature"
        
        static var defaultValue: Theme {
            return .default
        }
        
        static func fromString(_ string: String) -> Theme {
            switch string.lowercased() {
            case "commentary":
                return .commentary
            case "feature":
                return .feature
            default:
                return Theme.defaultValue
            }
        }
    }
    
    enum Style: String, Hashable, Codable {
        
        case `default` = "default"
        case breaking = "breaking"
        case crisis = "crisis"
        case depression = "depression"
        
        static var defaultValue: Style {
            return .default
        }
        
        static func fromString(_ string: String) -> Style {
            switch string {
            case "depression":
                return depression
            case "breaking":
                return breaking
            case "crisis":
                return crisis
            default:
                return Style.defaultValue
            }
        }
    }
    
    private(set) var theme = Theme.defaultValue
    private(set) var style = Style.defaultValue
    private(set) var forSmak = false
    
    convenience init() {
        self.init(theme: Theme.defaultValue, style: Style.defaultValue)
    }
    
    convenience init(theme: Theme, style: Style) {
        self.init(theme: theme, style: style, forSmak: false)
    }
    
    init (theme: Theme, style: Style, forSmak: Bool) {
        self.theme = theme
        self.style = style
        self.forSmak = forSmak
    }
    
    enum CodingKeys: String, CodingKey {
        case themeKey = "theme"
        case styleKey = "style"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.theme, forKey: .themeKey)
        try? container.encode(self.style, forKey: .styleKey)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? self.theme = container.decode(Theme.self, forKey: .themeKey)
        try? self.style = container.decode(Style.self, forKey: .styleKey)
    }
}

//MARK: - Hashable
extension ArticleStyle: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.theme.hashValue)
        hasher.combine(self.style.hashValue)
    }
}

// MARK: - Equatable
extension ArticleStyle: Equatable {
    static func ==(lhs: ArticleStyle, rhs: ArticleStyle) -> Bool {
        return (lhs.theme == rhs.theme) && (lhs.style == rhs.style)
    }
}
