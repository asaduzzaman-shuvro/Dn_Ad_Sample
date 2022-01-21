//
// Created by Apps AS on 23/02/16.
// Copyright (c) 2016 All rights reserved.
//
// PURE DATA
// Represents the details of an article

import Foundation

class Article: Component {

    enum Edition {
        case noEdition, dn, d2, magasinet, fordel

        static func newFromString(_ editionString: String) -> Edition {
            switch editionString.lowercased() {
                case "d2":
                   return .d2
                case "dn":
                    return .dn
                case "magazine":
                    return .magasinet
                case "fordel":
                    return .fordel
                default:
                    return .noEdition
            }
        }
        
        static func newHomeSectionFromString(_ homeSectionString: String) -> Edition {
            switch homeSectionString.lowercased() {
                case "d2":
                    return .d2
                case "dn":
                    return .dn
                case "magazine":
                    return .magasinet
                case "magasinet":
                    return .magasinet
                case "fordel":
                    return .fordel
                default:
                    return .noEdition
            }
        }
        
        static func editionIdentifierForLinkpulse(_ edition: Edition) -> String {
            switch edition {
                case .dn:
                    return "DN Edition"
                case .d2:
                    return "D2 Edition"
                case .magasinet:
                    return "Magasinet Edition"
                case .fordel:
                    return "Fordel Edition"
                default:
                    return "No Edition"
            }
        }
    }

    let id: String
    let style : ArticleStyle
    let publishedAt: Date
    let updatedAt: Date
    let title: String
    let plusContent: Bool
    let leadText: String
    let image: Image
    let kicker: String
    let publicLink: String
    let relatedVideoContent: VideoContent
    let relatedVideoImage: Image

    var isEmpty: Bool {
        return false
    }

    init (id: String, style: ArticleStyle, publishedAt: Date, updatedAt: Date, title: String, leadText: String, image: Image, kicker: String, publicLink: String, relatedVideoContent: VideoContent, relatedVideoImage: Image = Image.emptyImage, plusContent: Bool) {
        self.id = id
        self.style = style
        self.publishedAt = publishedAt
        self.updatedAt = updatedAt
        self.title = title
        self.plusContent = plusContent
        self.leadText = leadText
        self.image = image
        self.kicker = kicker
        self.publicLink = publicLink
        self.relatedVideoContent = relatedVideoContent
        self.relatedVideoImage = relatedVideoImage
    }
}
