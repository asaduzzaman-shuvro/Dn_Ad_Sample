//
//  CollectionViewSupplementaryViewInitialsType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewSupplementaryViewInitialsType {
    var headerReferenceSize: CGSize { get set}
    var footerReferenceSize: CGSize { get set}
    var headerPart: CollectionViewFeedPart? {get set}
}

protocol CollectionViewSupplementaryViewInitialsDefinerType {
    func getHeaderSize() -> CGSize
    func setHeaderSize(_ size: CGSize)
    func getFooterSize() -> CGSize
    func setFooterSize(_ size: CGSize)
    func getHeaderPart() -> CollectionViewFeedPart?
    func setHeaderPart(_ header: CollectionViewFeedPart?) 
}
