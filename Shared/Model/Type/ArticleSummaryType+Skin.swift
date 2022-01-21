//
//  ArticleSummaryType+Skin.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 16/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

enum Skin: String, Codable {
    struct SkinImage {
        let imageURI: String
        let size: CGSize
    }
    
    case dn = "dn"
    case d2 = "d2"
    case magasinet = "magasinet"
    case smak = "smak"
    case investor = "investor"
    case fiskeribladet = "fiskeribladet"
    case morgenbladet = "morgenbladet"
    case europower = "europower"
    case intrafish = "intrafish"
    case tekfisk = "tekfisk"
    case tradewinds = "tradewinds"
    case upstream = "upstream"
    case recharge = "recharge"
    case dntv = "dntv"
    case spesial = "spesial"
    case annonse = "annonse"
    case fremtid = "fremtid"
    case podkast = "podkast"
    
    static func getSkinType(from string: String) -> Skin? {
        switch string.lowercased() {
        case "dn":
            return .dn
        case "d2":
            return .d2
        case "magasinet":
            return .magasinet
        case "smak":
            return .smak
        case "investor":
            return .investor
        case "fiskeribladet":
            return .fiskeribladet
        case "morgenbladet":
            return .morgenbladet
        case "europower":
            return .europower
        case "intrafish":
            return .intrafish
        case "tekfisk":
            return .tekfisk
        case "tradewinds":
            return .tradewinds
        case "upstream":
            return .upstream
        case "recharge":
            return .recharge
        case "dntv":
            return .dntv
        case "spesial":
            return .spesial
        case "annonse":
            return .annonse
        case "fremtid":
            return .fremtid
        case "podkast":
            return .podkast
        default:
            return nil
        }
    }
}
