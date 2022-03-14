//
//  ArticleDetailChunk.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/1/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation

struct ArticleDetailChunk {
    private static let urlString = "https://www.dn.no/oslo-business-forum/obama/barack-obama-til-norge-i-september/2-1-374292?googfc"
    
    let articleId: String
    let publicLink: String
    let title: String
    let leadText: String
    
    class Builder {
        private var articleId: String = ""
        private var publicLink: String = ""
        private var title: String = ""
        private var leadText: String = ""
        
        init() {}
        
        init(summary: ArticleSummaryType) {
            self.articleId = summary.id
            self.publicLink = summary.publicUrl
            self.title = summary.title
            self.leadText = summary.leadText
        }
        
        @discardableResult
        func setArticleId(_ id: String) -> Builder {
            self.articleId = id
            return self
        }
        
        @discardableResult
        func setPublicLink(_ link: String) -> Builder {
            self.publicLink = link
            return self
        }
        
        @discardableResult
        func setTitle(_ title: String) -> Builder {
            self.title = title
            return self
        }
        
        @discardableResult
        func setLeadText(_ leadText: String) -> Builder {
            self.leadText = leadText
            return self
        }
        
        func build() -> ArticleDetailChunk {
            return ArticleDetailChunk(articleId: self.articleId,
                                      publicLink: self.publicLink,
                                      title: self.title,
                                      leadText: self.leadText)
        }
    }
}


// Builder for ArticleDetailChunk
extension ArticleDetailChunk {
    static func build(summary: ArticleSummaryType) -> ArticleDetailChunk {
        return ArticleDetailChunk(articleId: summary.id,
                                  publicLink: urlString,
                                  title: summary.title,
                                  leadText: summary.leadText)
    }
    
    static func build(publicLink: String) -> ArticleDetailChunk {
        return ArticleDetailChunk(articleId: String.getArticleId(from: urlString) ?? "",
                                  publicLink: urlString,
                                  title: "",
                                  leadText: "")
    }
}
