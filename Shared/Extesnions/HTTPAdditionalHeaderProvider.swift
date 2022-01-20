//
// Created by Apps AS on 25/03/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation

class HTTPAdditionalHeaderProvider {
    static let contentType = "application/json"
    static let userAgent = "DNApp_2020_IOS_\("1.0.0")"
    
    class func additionalHTTPHeadersForJSONQuery() -> [AnyHashable: Any] {
        return ["Content-Type": contentType, "User-Agent": userAgent]
    }
}
