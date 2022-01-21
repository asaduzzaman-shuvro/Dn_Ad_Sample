//
//  DNWebCookieManager.swift
//  DNApp
//
//  Created by Ashif Iqbal on 10/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DNWebCookieManager {
    class func removeAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        log(object: "DNWebCookieCleaner All cookies deleted")
        
        DispatchQueue.main.async {
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    log(object: "DNWebCookieCleaner Record \(record) deleted")
                }
            }
        }
    }
    
    class func shouldAuthorizeWithRedirection(_ completion: @escaping (_ redirect: Bool) -> Void){
        let dataStore = WKWebsiteDataStore.default()
        DispatchQueue.main.async {
            dataStore.httpCookieStore.getAllCookies({ (cookies) in
                let filteredArray = cookies.filter({($0.name.localizedCaseInsensitiveContains("VPW_ID"))})
                if filteredArray.count > 0{
                    completion(false)
                }
                else{
                    completion(true)
                }
            })
        }
    }
}
