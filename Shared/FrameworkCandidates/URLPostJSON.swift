//
// Created by Apps AS on 19/04/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import SwiftyJSON

class URLPostJSON {

    func postJSON(_ json: JSON, toURL: URL, httpAdditionalHeadersQuery: () -> [AnyHashable: Any], httpMethod: HTTPMethod = .post, completion: @escaping (_ json: JSON) -> Void, onError: @escaping (_ error: NSError?, _ data: Data?) -> Void) {
        URLSessionDataTask().onConfigureRequest { config in
            config.allowsCellularAccess = true
            config.timeoutIntervalForRequest = 30
            config.timeoutIntervalForResource = 60
            config.httpAdditionalHeaders = httpAdditionalHeadersQuery()
            if #available(iOS 13, *) {
                config.allowsConstrainedNetworkAccess = true
                config.allowsExpensiveNetworkAccess = true
            }
        }.onRequestHTTPMethod(httpMethod).onRequestCompleted(onThread: .background) { data in
            var json: JSON = [:]
            if data != nil && data!.count != 0 {
                do {
                    json = try JSON(data: data!, options: .allowFragments)
                } catch  {
                     onError(NSError(domain: "Can't parse to json", code: -9999, userInfo: nil),data)
                    return
                }
            }
            completion(json)
        }.onError { error, response, data in
            onError(error as NSError?, data)
        }.postJSONRequest(json, url: toURL)
    }
}
