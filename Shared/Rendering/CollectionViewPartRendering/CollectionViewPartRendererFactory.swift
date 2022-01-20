//
//  CollectionViewPartRendererFactory.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 9/5/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewPartRendererFactory {
    
    func newRenderer(forPart part: CollectionViewFeedPart, indexPath: IndexPath) -> CollectionViewPartRendering {
        switch Mirror(reflecting: part).subjectType {
            default:
                return GeneralCollectionViewPartRenderer(part: part, indexPath: indexPath)
        }
    }
    
    func sectionRendeer(forPart part: CollectionViewFeedPart, indexPath: IndexPath) -> CollectionViewPartRendering {
           switch Mirror(reflecting: part).subjectType {
               default:
                   return GeneralCollectionViewPartRenderer(part: part, indexPath: indexPath)
           }
       }
}
