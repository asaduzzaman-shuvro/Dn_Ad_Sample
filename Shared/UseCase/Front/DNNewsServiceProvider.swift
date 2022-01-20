//
//  DNNewsServiceProvider.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 23/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import SwiftyJSON

class DNNewsServiceProvider {
    fileprivate let pageType: PageType
    fileprivate let feedUrlString: String
    
    init(pageType: PageType, feedUrlString: String) {
        self.pageType = pageType
        self.feedUrlString = feedUrlString
    }
    
    fileprivate func reportAPIFail(_ urlString: String) {
        var extraContextData: [String: String] = [String: String] ()
        extraContextData["end_point"] = urlString
    }
    
    fileprivate func dataToJSON(_ data: Data) -> (json: JSON?, error: NSError?) {
        var json: JSON?
        do {
            json = try JSON(data: data)
            return (json:json, error: nil)
        } catch let error as NSError {
            return (json:json, error:error)
        }
    }

    private func requestNewsFeedAsync(withUrl url: URL,completion: @escaping (_ json: JSON) -> Void, onError: @escaping (_ error: NSError?) -> Void, cachePolicy: NSURLRequest.CachePolicy?) {
        URLSessionDataTask().onConfigureRequest { config in
            config.allowsCellularAccess = true
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 60
            config.httpAdditionalHeaders = HTTPAdditionalHeaderProvider.additionalHTTPHeadersForJSONQuery()
        }.onRequestCompleted(onThread: .background) { data in
            NSLog("\(String(describing: data?.count)) news feed bytes arrived.")
            do {
                let json = try JSON(data: data!)
                completion(json)
            } catch let serializationError as NSError {
                onError(NSError(domain: "ParseErro", code: -9999, userInfo: nil))
                return
            }
        }.onError { error, response, data in
            self.reportAPIFail(url.absoluteString)
            onError(NSError(domain: "CommunicationError", code: 5, userInfo: nil))
        }.requestFromURL(url, cachePolicy: cachePolicy)
    }
    
    func requestNewsFeedAndCacheAsync(withPageInfo pageInfo: PageInfo?, _ completion: @escaping (_ cachedJSON: JSON?, _ json: JSON?, _ error: NSError?) -> Void, onError:@escaping (_ error: NSError?) -> Void) {
        
        let original = feedUrlString
        let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: encoded!)!
        
        var urlComponents:URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let pageInfo = pageInfo {
            urlComponents.queryItems = [
                URLQueryItem(name: "page", value: "\(pageInfo.currentPage)")
            ]
        }
        
        guard let componentsUrl = urlComponents.url else {
            return
        }
        log(object: componentsUrl)
        
        URLSessionDataTask().onConfigureRequest { config in
            config.allowsCellularAccess = true
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 60
            config.httpAdditionalHeaders = HTTPAdditionalHeaderProvider.additionalHTTPHeadersForJSONQuery()
            }.onRequestCompleted(onThread: .background) { data in
                let result = self.dataToJSON(data!)
                let cachedJSON = result.error == nil ? result.json : nil
                self.requestNewsFeedAsync(withUrl: componentsUrl, completion: { (json) in
                    completion(cachedJSON, json, nil)
                }, onError: { (error) in
                    if cachedJSON != nil {
                        completion(cachedJSON, nil, error)
                    } else {
                        onError(error)
                    }
                }, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData)
            }.onError { error, response, data in
                self.requestNewsFeedAsync(withUrl: componentsUrl, completion: { (json) in
                    completion(nil, json, nil)
                }, onError: { (error) in
                    onError(error)
                }, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData)
            }.requestFromURL(componentsUrl, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataDontLoad)
    }
}
