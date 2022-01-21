//
//  DNWebUtil.swift
//  DNApp
//
//  Created by Ashif Iqbal on 29/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit

enum WebEmbedViewType{
    case article
    case external
}

class DNWebUtil {
    static let sharedInstance = DNWebUtil()
    
    fileprivate let dnWebHost = "www.dn.no"
    fileprivate let dnDirekteHost = "direkte.dn.no"
    fileprivate let dnWebHostStage = "stage.dn.no"
    fileprivate let dnWebHostTest = "test.dn.no"
    fileprivate let investorHost = "investor.dn.no"
    fileprivate let dnTvHost = "dntv.dn.no"
    fileprivate let idnHost = "idn.dn.no"
    fileprivate let playCastHost = "play.acast.com"
    fileprivate let gaselleUrl = "https://www.dn.no/gaselle"
    fileprivate let servicesDnHost = "services.dn.no"
    fileprivate let targetContentSourceUrl = "www.dn.no/staticprojects/kommersielt/tilbud/"
    
    fileprivate let nhstHost = "nhst.no"
    
    fileprivate lazy var supportedHost = [dnWebHost, dnDirekteHost, dnWebHostStage, dnWebHostTest, dnTvHost, investorHost]
    
    fileprivate lazy var allowedHost = [dnWebHost, dnDirekteHost, dnWebHostStage, dnWebHostTest, dnTvHost, investorHost, idnHost, playCastHost, servicesDnHost]
    
    fileprivate let supportedPaths = ["kundeservice", "min-side", "nyhetsbrev", "vilkar-dnno", "sudoku", "usa-valget-2020", "dn-ledelse", "faq", "skattelister", "boligpriser", "podkast", "aksjer", "fremtid"]
    fileprivate let webHeaderTitle = ["min-side" : "Min side", "nyhetsbrev" : "Nyhetsbrev",
                                      "vilkar-dnno" : "Vilkår", "sudoku" : "Sudoku",
                                      "usa-valget-2020" : "USA-valget", "dn-ledelse" : "Ledelse",
                                      "faq" : "Spørsmål og svar", "skattelister" : "Skattelister",
                                      "boligpriser" : "Boligbasen", "kundeservice": "Kundeservice", "podkast" : "Podkast", "aksjer" : "Aksjer", "fremtid" : "Fremtid"]
    
    private let supportedOtherNavigationActionPath = ["giftArticle","toggleWineList","toggleFavorite"]
    
    func getType(for urlString: String) -> (type: WebEmbedViewType, sourceUrlString: String) {
        guard let url = URL(string: urlString) else {
            return (.external,urlString)
        }
        return self.getType(for: url)
    }
    
    func getType(for url: URL) -> (type: WebEmbedViewType, sourceUrlString: String) {

        log(object: "Mapping urlString:\(url.absoluteString)")
        
        if let host = url.host?.lowercased() {
            if host.contains(self.dnWebHost) || host.contains(self.dnWebHostStage) || host.contains(self.dnWebHostTest) {
                if String.getArticleId(from: url) != nil {
                    return (.article, url.absoluteString)
                }
            }else if host.contains(self.investorHost) {
                
                let urlStr = self.getProcessedUrlForInvestor(source: url)
                return (.external, urlStr)
            }
        }
        
        return (.external, url.absoluteString)
    }
    
    func isAllowedHostForNativeWebView(urlString: String) -> Bool{
        if let url = URL(string: urlString), let host = url.host?.lowercased(), allowedHost.contains(host), !url.absoluteString.contains(targetContentSourceUrl){
            return true
        }
        return false
    }
    
    
    func isAllowableHostForNHST(urlString: String) -> Bool {
        if let url = URL(string: urlString), let host = url.host?.lowercased(), host.contains(self.nhstHost) {
            return true
        }
        return false
    }
    
    func isDNProjectArticle(urlStr: String) -> Bool{
        guard let url = URL(string: urlStr) else {
            return false
        }
        if let host = url.host?.lowercased() {
            if supportedHost.contains(host) && url.absoluteString != gaselleUrl{
                return true
            }
        }
        return false
    }
    
    func shouldShowNativeHeader(urlStr: String) -> Bool{
        guard let url = URL(string: urlStr) else {
            return false
        }
        if isHostEqualDN(url: url) || isHostEqualDirekteDN(url: url){
            for component in url.pathComponents {
                if supportedPaths.contains(component){
                    return true
                }
            }
        }
        return false
    }
    
    func getNativeHeaderTitle(urlStr: String) -> String? {
        guard let url = URL(string: urlStr), isHostEqualDN(url: url) || isHostEqualDirekteDN(url: url) else {
            return nil
        }
        
        var title: String?
        for component in url.pathComponents {
            if let currentPathTitle = webHeaderTitle[component] {
                title = currentPathTitle
            }
        }
        return title
    }
    
    func shouldAllowNavigationAction(url: URL?) -> Bool{
        guard let receivedUrl = url else {
            return true
        }
        if isHostEqualDN(url: receivedUrl){
            for component in receivedUrl.pathComponents {
                if component == "logout"{
                    return false
                }
            }
        }
        return true
    }
    
    fileprivate func isHostEqualDN(url: URL) -> Bool{
        if let host = url.host?.lowercased() {
            if host.contains(self.dnWebHost) || host.contains(self.dnWebHostStage) || host.contains(self.dnWebHostTest){
                return true
            }
        }
        return false
    }
    
    fileprivate func isHostEqualNHST(url: URL) -> Bool {
        if let host = url.host?.lowercased(), host == self.nhstHost {
            return true
        }
        return false
    }
    
    fileprivate func isHostEqualDirekteDN(url: URL) -> Bool{
        if let host = url.host?.lowercased() {
            if host.contains(self.dnDirekteHost){
                return true
            }
        }
        return false
    }
    
    func isHostEqualInvestorDN(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return self.isHostEqualInvestorDN(url: url)
        }
        
        return false
    }
    
    func isHostEqualInvestorDN(url: URL) -> Bool {
        if let host = url.host?.lowercased(), host.contains(self.investorHost) {
            return true
        }
        
        return false
    }
    
    func shouldAllowOtherNavigationAction(url: URL?) -> Bool {
        guard let receivedUrl = url, self.isHostEqualDN(url: receivedUrl) else {
            return false
        }
        
        for path in receivedUrl.pathComponents {
            if self.supportedOtherNavigationActionPath.contains(path) {
                return true
            }
        }
        
        return false
    }
    
    fileprivate func getProcessedUrlForInvestor(source: URL)-> String{
        var urlStr = source.absoluteString
        for component in source.pathComponents {
            if component == "p"{
                urlStr = urlStr.replacingOccurrences(of: "/p/", with: "/#!/Oversikt/Direkte/")
                break;
            }
        }
        urlStr = urlStr.replacingOccurrences(of: "investor.dn.no", with: "investor.dn.no/app")
        return urlStr
    }
    
    func getQueryParameterValue(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

extension CharacterSet {

    static var urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"  // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return allowed
    }()
}
