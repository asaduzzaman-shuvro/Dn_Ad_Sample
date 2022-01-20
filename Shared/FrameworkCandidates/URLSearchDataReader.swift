//
//  URLSearchDataReader.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 8/9/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import SwiftyJSON

class URLSearchDataReader: URLDataReader {
    let sessionDataTask: URLSessionDataTask = URLSessionDataTask()
    
    func requestJSONFromUrlAsync(_ url: URL, withRequestBody body: JSON? = nil, httpAdditionalHeadersQuery: () -> [AnyHashable : Any], httpMethod: HTTPMethod = .get, cachePolicy: NSURLRequest.CachePolicy? = nil, completion: @escaping (JSON) -> Void, onError: @escaping (NSError?) -> Void, onAccesDenied: ((_ statusCode: Int)-> Void)? = nil) {
        self.sessionDataTask.onConfigureRequest { config in
            config.allowsCellularAccess = true
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 60
            config.httpAdditionalHeaders = httpAdditionalHeadersQuery()
            if #available(iOS 13, *) {
                config.allowsConstrainedNetworkAccess = true
                config.allowsExpensiveNetworkAccess = true
            }
        }.onRequestHTTPMethod(httpMethod)
        .onRequestHTTBody(body)
        .onRequestCompleted(onThread: .background) { data in
            do {
                let json = try JSON(data: data!, options: .allowFragments)
                completion(json)
            } catch let error as NSError {
                onError(error)
                return
            }
        }.onError { error, response, data in
            onError(error as NSError?)
        }.onlogOut(onAccesDenied).requestFromURL(url, cachePolicy: cachePolicy)
    }

    func cancelCurrenDataTask() {
        let dataTask = sessionDataTask.getCurrenDataTask()
        guard dataTask?.state == .running else {
            return
        }
        dataTask?.cancel()
    }
}
