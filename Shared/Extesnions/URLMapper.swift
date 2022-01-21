//
//  URLMapper.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 27/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class URLMapper {
    static let sharedInstance = URLMapper()
    
    enum URLType {
        case dnWeb(DNWebURLType)
        case web(WebURLType)
        case nhstWeb(WebURLType)
        case investor
        case dntv
        case email(URL)
        case phone(URL)
        case sms(URL)
    }
    
    enum DNWebURLType {
        case home
        case topic(String)
        case purchase
        case articleGift
        case wineListing
        case wineFavourite
        case other
        
        func getTopicIdentifier() -> String? {
            switch self {
            case .topic(let identifier):
                return identifier
            default:
                return nil
            }
        }
    }
    
    enum WebURLType {
        case openInside
        case openExternally
        
        func shouldOpenInside() -> Bool {
            switch self {
            case .openInside:
                return true
            default:
                return false
            }
        }
    }
    
    fileprivate let dnWebHost = "www.dn.no"
    fileprivate let dnWebHostStage = "stage.dn.no"
    fileprivate let dnWebHostTest = "test.dn.no"
    fileprivate let investorHost = "investor.dn.no"
    fileprivate let dntvHost = "dntv.dn.no"
    fileprivate let privacyHost = "privacy.nhst.no"
    
    fileprivate let articleGiftHost = "open.dnapp.no"
    fileprivate let articleGiftDynamicLinkDomainURIPrefix = "https://dnapp.page.link"
    
    fileprivate let investor_url_app_regex = "/app"
    fileprivate let investor_url_p_regex = "/p"
    
    func getType(for urlString: String) -> URLType? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return self.getType(for: url)
    }
    
    func getType(for url: URL) -> URLType? {
        log(object: url)
       
        if let scheme = url.scheme {
            if scheme == "mailto"{
                return .email(url)
            }
            if scheme == "tel" {
                return .phone(url)
            }
            
            if scheme == "sms"{
                return .sms(url)
            }
        }
        
        if DNWebUtil.sharedInstance.isAllowedHostForNativeWebView(urlString: url.absoluteString){
            if let host = url.host?.lowercased() {
                if host.contains(self.dnWebHost) || host.contains(self.dnWebHostStage) || host.contains(self.dnWebHostTest) {
                    let inherentType = self.getUrlTypeForDNWeb(url)
                    return .dnWeb(inherentType)
                }else if host.contains(self.investorHost) {
                    return .investor
                }else if host.contains(self.dntvHost) {
                    return .dntv
                } else {
                    return .web(self.getWebUrlType(url.absoluteString))
                }
            }
        } else if DNWebUtil.sharedInstance.isAllowableHostForNHST(urlString: url.absoluteString) {
            let inherentType = self.getUrlTypeForNHSTWeb(url)
            return .nhstWeb(inherentType)
        }else{
            return .web(self.getWebUrlType(url.absoluteString))
        }
        
        return nil
    }
    
    fileprivate func getWebUrlType(_ urlString: String) -> WebURLType {
        if !DNWebUtil.sharedInstance.isAllowedHostForNativeWebView(urlString: urlString){
            return .openExternally
        } else {
           return .openInside
        }
    }
    
    fileprivate func getUrlTypeForDNWeb(_ url: URL) -> DNWebURLType {
        if self.isDNHomeURL(url) {
            return .home
        } else if self.isDNTopicURL(url) {
            if let identifier = self.findTopicIdentifier(from: url) {
                return .topic(identifier)
            }
        } else if self.isDNPurchaseURL(url) {
            return .purchase
        } else if self.isDNArticleGiftURL(url) {
            return .articleGift
        } else if self.isWineListUrl(url) {
            return .wineListing
        } else if self.isWineFavouriteUrl(url) {
            return .wineFavourite
        }
        return .other
    }
    
    private func getUrlTypeForNHSTWeb(_ url: URL) -> WebURLType {
        if url.host == self.privacyHost {
            return .openInside
        }
        return .openExternally
    }
}

extension URLMapper {
    fileprivate func isDNHomeURL(_ url: URL) -> Bool {
        let sanitizedPathComponents = url.pathComponents.filter({$0 != "/"})
        
        if sanitizedPathComponents.isEmpty {
            return true
        }
        
        return false
    }
    
    fileprivate func isDNTopicURL(_ url: URL) -> Bool {
        if url.pathComponents.contains("topic") {
            return true
        }
        return false
    }
    
    fileprivate func findTopicIdentifier(from url: URL) -> String? {
        if let index = url.pathComponents.firstIndex(of: "topic"), index + 1 < url.pathComponents.count {
            return url.pathComponents[index + 1]
        }
        
        return nil
    }
    
    fileprivate func isDNPurchaseURL(_ url: URL) -> Bool {
        if url.pathComponents.contains("bli-abonnent") {
            return true
        }
        return false
    }
    
    private func isDNArticleGiftURL(_ url: URL) -> Bool {
        if url.pathComponents.contains("giftArticle") {
            return true
        }
        
        return false
    }
    
    private func isWineFavouriteUrl(_ url: URL) -> Bool {
        if url.pathComponents.contains("toggleFavorite") {
            return true
        }
        return false
    }
    
    private func isWineListUrl(_ url: URL) -> Bool {
        if url.pathComponents.contains("toggleWineList") {
            return true
        }
        
        return false
    }
}

// Investor URL Processing
extension URLMapper {
    func preprocessInvestorUrl(_ url: URL) -> URL {
        if let processedUrl = URL(string: self.preprocessInvestorUrlString(url.absoluteString)) {
            return processedUrl
        }
        
        return url
    }
    
    func preprocessInvestorUrlString(_ urlString: String) -> String {
        var processedUrlString = urlString
        
        guard let hostRange = processedUrlString.range(of: self.investorHost, options: .regularExpression) else {
            return processedUrlString
        }
        
        if processedUrlString.range(of: self.investor_url_app_regex, options: .regularExpression) == nil {
            processedUrlString = processedUrlString.replacingCharacters(in: hostRange, with: "\(self.investorHost)/app")
        }
        
        if let range = processedUrlString.range(of: self.investor_url_p_regex, options: .regularExpression) {
            processedUrlString = processedUrlString.replacingCharacters(in: range, with: "/#!/Oversikt/Direkte")
        }

        return processedUrlString
    }
}

// Additional query parameter processing
extension URLMapper{
    func appendVisitorInfoForUrl(url: URL, _ completion: @escaping (_ appendedUrl: URL) -> Void){
        var queryTag = "?"
        if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           urlComponents.queryItems != nil{
            queryTag = "&"
        }
        var urlParams = "\(queryTag)view=noheader"

        let urlStr = self.processUrlStringWithAdditionalQueryParams(urlString: url.absoluteString, queryParam: urlParams)
        if let resultUrl = URL(string: urlStr){
            completion(resultUrl)
        }else{
            completion(url)
        }
    }
    
    fileprivate func processUrlStringWithAdditionalQueryParams(urlString: String, queryParam: String) -> String {
        var processedUrlString = urlString
        if let range = processedUrlString.range(of: "#!", options: .regularExpression) {
            processedUrlString = processedUrlString.replacingCharacters(in: range, with: "\(queryParam)#!")
        }else{
            processedUrlString = "\(processedUrlString)\(queryParam)"
        }
        
        return processedUrlString
    }
}




//MARK: - Article Gift
extension URLMapper {
    func urlStringForArticleShareWebLink(articlePublicUrlString: String, shareToken: String? = nil) -> URL? {
        guard let articlePublicUrl = URL(string: articlePublicUrlString) else {
            return nil
        }
        
        var urlComponents = articlePublicUrl.urlComponents
        
        if let token = shareToken {
            let shareTokenQueryItem = URLQueryItem(name: "shareToken", value: token)
            
            if urlComponents.queryItems?.isEmpty ?? true {
                urlComponents.queryItems = [shareTokenQueryItem]
            }else {
                urlComponents.queryItems?.append(shareTokenQueryItem)
            }
        }
        
        return urlComponents.url
    }
    
    func urlStringForArticleShareAppLink(articleId: String, shareToken: String? = nil) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = self.articleGiftHost
        urlComponents.path = "/article/\(articleId)"
        if let token = shareToken{
            let queryItem = URLQueryItem(name: "shareToken", value: token)
            urlComponents.queryItems = [queryItem]
        }
        
        return urlComponents.url
    }
    
    func getArticleGiftShareToken(from url: URL) -> String? {
        return self.getArticleGiftShareToken(from: url.queryItems)
    }
    
    func getArticleGiftShareToken(from queryItems: [URLQueryItem]?) -> String? {
        let shareTokenQueryItem = queryItems?.first(where: {
            $0.name == "shareToken"
        })
        
        return shareTokenQueryItem?.value
    }
}
