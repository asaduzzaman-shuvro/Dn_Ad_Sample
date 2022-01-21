//
//  URL+Extensions.swift
//  DNApp
//
//  Created by Ashif Iqbal on 11/11/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    func openExternally(){
        DispatchQueue.main.async {
            UIApplication.shared.open(self, options: [:], completionHandler: nil)
        }
    }
}

extension URL {
    var queryItems: [URLQueryItem]? {
        let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        return urlComponents?.queryItems
    }
    
    var fragments: String? {
        let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        return urlComponents?.fragment
    }
    
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = self.path
        urlComponents.queryItems = self.queryItems ?? []
        urlComponents.fragment = self.fragments
        
        return urlComponents
    }
}
