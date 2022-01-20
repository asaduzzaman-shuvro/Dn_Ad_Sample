//
//  NewsFeedViewControllerDelegate.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 23/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol NewsFeedViewControllerDelegate: SearchableContentDelegate, SearchViewPresentingController, AdComponentDelegate, WebContentViewCellDelegate, ScrollViewEventProtocol {
    
    var previouslyTappedArticleId: String? { get set }
    
    func start()
    func refresh(pullToRefresh: Bool)
    func refetchDataForError() 
    func partSelected(_ part: CollectionViewFeedPart)
}


protocol ScrollViewEventProtocol {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView)
}
