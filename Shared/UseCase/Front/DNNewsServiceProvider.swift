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

    
    func requestNewsFeedAndCacheAsync(withPageInfo pageInfo: PageInfo?, _ completion: @escaping (_ cachedJSON: JSON?, _ json: JSON?, _ error: NSError?) -> Void, onError:@escaping (_ error: NSError?) -> Void) {
        
        completion(nil, try? self.loadDummyJSON(), nil)
    }
    
    func loadDummyJSON() throws -> JSON {
        guard let url = Bundle.main.url(forResource: "dummy_front", withExtension: "json") else {
            throw(NSError(domain: "Can't find the url", code: -1, userInfo: nil))
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSON(data: data)
        } catch let error {
            throw(error)
        }
    }
}
