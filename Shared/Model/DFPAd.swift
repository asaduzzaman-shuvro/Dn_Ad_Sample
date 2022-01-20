//
//  DFPAd.swift
//  DNApp
//
//  Created by Ashif Iqbal on 12/4/18.
//  Copyright © 2018 no.dn.dn. All rights reserved.
//

import UIKit

class DFPAd: Component, Codable {
    static let emptyAd = DFPAd()
    
    private(set) var provider : String = ""
    private(set) var mobileAdSize : CGSize = .zero
    private(set) var tabletAdSize : CGSize = .zero
    private(set) var mobileAdUnitId : String = ""
    private(set) var tabletAdUnitId : String = ""
    private(set) var sizeType: String = ""
    
    var adSize : CGSize {
        return UIDevice.current.userInterfaceIdiom == .pad ? tabletAdSize : mobileAdSize
    }
    
    var adUnitId : String {
        return UIDevice.current.userInterfaceIdiom == .pad ? tabletAdUnitId : mobileAdUnitId
    }
    
    var isEmpty: Bool {
        return false
    }
    
    init() {}
    
    
    init(provider: String, mobileAdSize: CGSize, tabletAdSize: CGSize, mobileAdUnitId: String, tabletAdUnitId: String, sizeType: String) {
        self.provider = provider
        self.mobileAdSize = mobileAdSize
        self.tabletAdSize = tabletAdSize
        self.mobileAdUnitId = mobileAdUnitId
        self.tabletAdUnitId = tabletAdUnitId
        self.sizeType = sizeType
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case providerKey = "provider"
        case mobileAdSizeKey = "mobile_ratio"
        case tabletAdSizeKey = "tablet_ratio"
        case mobileAdUnitIDKey = "mobile_alias"
        case tabletAdUnitIDKey = "tablet_alias"
        case sizeTypeKey = "size_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(self.provider, forKey: .providerKey)
        try? container.encode(self.mobileAdSize.toAPIModel(), forKey: .mobileAdSizeKey)
        try? container.encode(self.tabletAdSize.toAPIModel(), forKey: .tabletAdSizeKey)
        try? container.encode(self.mobileAdUnitId, forKey: .mobileAdUnitIDKey)
        try? container.encode(self.tabletAdUnitId, forKey: .tabletAdUnitIDKey)
        try? container.encode(self.sizeType, forKey: .sizeTypeKey)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try? self.provider = container.decode(String.self, forKey: .providerKey)
        try? self.mobileAdSize = container.decode(CGSize.APIModel.self, forKey: .mobileAdSizeKey).toCGSize()
        try? self.tabletAdSize = container.decode(CGSize.APIModel.self, forKey: .tabletAdSizeKey).toCGSize()
        try? self.mobileAdUnitId = container.decode(String.self, forKey: .mobileAdUnitIDKey)
        try? self.tabletAdUnitId = container.decode(String.self, forKey: .tabletAdUnitIDKey)
        try? self.sizeType = container.decode(String.self, forKey: .sizeTypeKey)
    }
}
