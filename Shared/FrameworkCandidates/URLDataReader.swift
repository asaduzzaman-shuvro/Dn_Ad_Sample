//
// Created by Apps AS on 25/03/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import SwiftyJSON

class URLDataReader {
    func requestJSONFromUrlAsync(_ url: URL,withRequestBody body: JSON? = nil
                                 , httpAdditionalHeadersQuery: () -> [AnyHashable: Any], httpMethod: HTTPMethod = .get, cachePolicy: NSURLRequest.CachePolicy? = nil, completion: @escaping (_ json: JSON) -> Void, onError: @escaping (_ error: NSError?) -> Void) {
        URLSessionDataTask().onConfigureRequest { config in
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
            var json: JSON = [:]
            if let responseData = data, !responseData.isEmpty {
                do {
                    json = try JSON(data: responseData, options: .allowFragments)
                } catch {
                    onError(JSON.createJSONSerializationError())
                    return
                }
            }else {
                //FIXME: - Send error in case of empty data
            }
            completion(json)
        }.onError { error, response, data in
            onError(error as NSError?)
        }.requestFromURL(url, cachePolicy: cachePolicy)
    }
}
