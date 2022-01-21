//
//  ArticleSummaryType+ViewType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 20/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

enum ViewType: String, Codable {
    case `default` = "DEFAULT"
    case edition_spesial = "EDITION_SPESIAL"
    case commercial_spesial = "COMMERCIAL_SPESIAL"
    case siste = "SISTE"
    
    static var defaultValue: ViewType {
        return .default
    }
    
    static func getViewType(from string: String) -> ViewType {
        switch string.lowercased() {
        case "edition_spesial":
            return .edition_spesial
        case "commercial_spesial":
            return .commercial_spesial
        default:
            return .default
        }
    }
}
