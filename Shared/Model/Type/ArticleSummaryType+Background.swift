//
//  ArticleSummaryType+Background.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 16/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

enum Background: String, Codable {
    case none = ""
    case highlight = "highlight"
    
    static var defaultValue: Background {
        return .none
    }
    
    static func getBackgroundType(from string: String) -> Background {
        switch string.lowercased() {
        case "highlight":
            return .highlight
        default:
            return .none
        }
    }
}
