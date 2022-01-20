//
//  URLPutJSON.swift
//  DNApp
//
//  Created by Ashif Iqbal on 24/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import SwiftyJSON

class URLPutJSON {
    func putJSON(_ json: JSON, toURL: URL, httpAdditionalHeadersQuery: () -> [AnyHashable: Any], httpMethod: HTTPMethod = .put, completion: @escaping (_ json: JSON) -> Void, onError: @escaping (_ error: NSError?, _ data: Data?) -> Void) {
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
        }.putJSONRequest(json, url: toURL)
    }
}
