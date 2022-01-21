//
//  String+Extension.swift
//  GoogleAdSample (iOS)
//
//  Created by Asaduzzaman Shuvro on 21/1/22.
//

import Foundation

extension String {
    static func getArticleId(from urlString: String) -> String? {
        if let url = URL(string: urlString) {
            return getArticleId(from: url.pathComponents)
        }
        
        return nil
    }
    
    static func getArticleId(from url: URL) -> String? {
        return getArticleId(from: url.pathComponents)
    }
    
    static func getArticleId(from pathComponents: [String]) -> String? {
        for component in pathComponents {
            if isArticleId(component) {
                return component
            }
        }
        return nil
    }
    
    fileprivate static func isArticleId(_ identifier: String) -> Bool {
        let articleIdRegEx = "^\\d-\\d-[a-zA-Z0-9]+$"
        
        let articleId = identifier.trimmingCharacters(in: .whitespaces)
        
        let articleIdTest = NSPredicate(format: "SELF MATCHES %@", articleIdRegEx)
        
        return articleIdTest.evaluate(with: articleId)
    }
    
    func toNotifationName() -> NSNotification.Name {
        return Notification.Name(rawValue: self)
    }
}
