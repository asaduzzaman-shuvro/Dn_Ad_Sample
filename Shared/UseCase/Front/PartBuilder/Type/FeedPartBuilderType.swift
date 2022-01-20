//
//  FeedPartBuilderType.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol FeedPartBuilderType: AnyObject {
    func buildUpParts(components: [Component], bounds: CGSize, scrollDirection: UICollectionView.ScrollDirection) -> [CollectionViewSectionInfoProviding]
    func buildUpPart(for component: Component, isFirstComponentInSection firstComponentFlag: Bool, isLastComponentInSection lastComponentFlag: Bool, context: FeedMappingContextType) -> CollectionViewFeedPart
}

