//
//  PageType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

/// Constants for representing edition type.
///
/// - Todo:
/// Need to refactor and remove `smak` as edition.
///
/// - Note:
/// If `smak` is not used as edition we'll need to make change to adobe track.
enum EditionType: Equatable {
    case d2, magasinet, smak(SmakInherntType)
    
    /// Provides string value of the type.
    var stringValue: String {
        switch self {
        case .d2:
            return "d2"
        case .magasinet:
            return "magazine"
        default:
            return "smak"
        }
    }
    
    /// Provides logo image uri of the edition type.
    var logoImageUri: String {
        switch self {
        case .d2:
            return "icon_logo_d2"
        case .magasinet:
            return "icon_logo_magasinet"
        case .smak:
            return "icon_logo_smak"
        }
    }
    
    /// Provides tab bar item index for the edition type.
    var tabItemIndex: Int {
        switch self {
        case .d2:
            return 3
        case .magasinet:
            return 4
        case .smak:
            return 5
        }
    }
    
    static func getEditionType(from string: String, inherenType: Int ) -> EditionType? {
        switch string.lowercased() {
        case "d2":
            return .d2
        case "magazine", "magasinet":
            return .magasinet
        case "smak":
            switch inherenType {
            case 1:
                return .smak(.smakSearch)
            case 2:
                return .smak(.smkaReciepe)
            case 3:
                return .smak(.smkaRestaurant)
            default:
                return .smak(.smakFeed)
            }
        default:
            return nil
        }
    }
    
    static func isEdition(identifier string: String) -> Bool {
        switch string.lowercased() {
        case "d2", "magazine", "magasinet", "smak":
            return true
        default:
            return false
        }
    }
    
    static func isEditionInlineFeed(identifier: String) -> Bool {
        let sanitizedIdentifier = identifier.replacingOccurrences(of: "_carousel", with: "")
        
        return isEdition(identifier: sanitizedIdentifier)
    }
    
    static func getEditionType(forInlineFeedIdentifier identifier: String) -> EditionType? {
        let sanitizedIdentifier = identifier.replacingOccurrences(of: "_carousel", with: "")
        
        return getEditionType(from: sanitizedIdentifier, inherenType: 0)
    }
    
    static func ==(lhs: EditionType, rhs: EditionType) -> Bool {
        switch (lhs, rhs) {
        case (.d2, .d2):
            return true
        case (.magasinet, .magasinet):
            return true
        case (.smak, .smak):
            return true
        default:
            return false
        }
    }
}

// MARK: - Codable
extension EditionType: Codable {
    /// Encode this model to the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: This function throws encoding errors.
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try? container.encode(self.stringValue)
    }
    
    /// Create a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: This function throws decoding errors.
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        switch stringValue.lowercased() {
        case EditionType.d2.stringValue:
            self = .d2
        case EditionType.magasinet.stringValue:
            self = .magasinet
        case EditionType.smak(.smakFeed).stringValue:
            self = .smak(.smakFeed)
        default:
            throw DecodingError.typeMismatch(EditionType.self, DecodingError.Context(codingPath: [], debugDescription: "Could not create edition type from the value."))
        }
    }
}

enum SmakInherntType : Int {
    case smakFeed = 0
    case smakSearch = 1
    case smkaReciepe = 2
    case smkaRestaurant = 3
}

/// Constants for representing page type inside the app.
enum PageType {
    /// Menu page type.
    case menu
    
    /// Favourite page type.
    case favorite
    
    /// Favourite article's page type.
    case favoriteArticle
    
    /// Bookmark article's page type.
    case bookmarkArticle
    
    /// Favourite search's page type.
    case favoriteSearch
    
    /// Home page's type.
    case front
    
    /// Edition page's type. Associated value represents actual edition type.
    case edition(EditionType)
    
    /// Tag page's type.
    case topic
    
    /// Section page's type.
    case section
    
    /// Latest news page's type.
    case sisteNytt
    
    /// Search page's type.
    case search
    
    /// Smak search page's type.
    case smakSearch
    
    /// Min smak page's type.
    case minSmak

    case minSmakDetails
    
    /// News letter summary page's type.
    case newsletterSummary
}

extension PageType: Equatable {
    /// Checks if two `PageType` are equal.
    /// - Parameters:
    ///   - lhs: `PageType` to compare.
    ///   - rhs: `PageType` to compare.
    /// - Returns: Return `true` if they are equal or `false` otherwise.
    static func == (lhs: PageType, rhs: PageType) -> Bool {
        switch (lhs, rhs) {
        case (.front, .front):
            return true
        case (.edition(let edition1), .edition(let edition2)):
            /// Compare actual edition types.
            return edition1 == edition2
        case (.topic, .topic):
            return true
        case (.section, .section):
            return true
        case (.sisteNytt, .sisteNytt):
            return true
        case (.search, .search):
            return true
        case (.smakSearch,.smakSearch):
            return true
        case (.favoriteSearch, .favoriteSearch):
            return true
        case (.bookmarkArticle, .bookmarkArticle):
            return true
        case (.favoriteArticle, .favoriteArticle):
            return true
        case (.favorite, .favorite):
            return true
        case (.menu, .menu):
            return true
        case (.newsletterSummary, .newsletterSummary):
            return true
        case (.minSmak, .minSmak):
            return true
        case (.minSmakDetails, .minSmakDetails):
            return true
        default:
            return false
        }
    }
}
