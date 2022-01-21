//
//  ArticleSummaryType+Priority.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 16/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

enum Priority: String, Codable {
    case aPlus = "A+"
    case a = "A"
    case b = "B"
    case cFlow = "C-Flow"
    
    static func getPriority(from string: String) -> Priority? {
        switch string.lowercased() {
        case "a+":
            return .aPlus
        case "a":
            return .a
        case "b":
            return .b
        case "c-flow":
            return .cFlow
        default:
            return nil
        }
    }
}
