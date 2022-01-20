//
//  HorizontalPaginationDelegate.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 29/10/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol PaginationDelegate: AnyObject {
    func refreshAll(completion: @escaping(_ isSucceed: Bool) -> Void)
    func loadMore(completion: @escaping(_ isSucceed: Bool) -> Void)
}

extension PaginationDelegate {
    func refreshAll(completion: @escaping(_ isSucceed: Bool) -> Void) {
        completion(true)
    }
}

protocol PaginationProvider: AnyObject  {
    var pageInfo: PageInfo {get set}
   
    var isObservingKeyPath: Bool {get set}
    var isEnabled: Bool{get set}
    var isLoadMoreEnabled: Bool {get set}
    var scrollView: UIScrollView {get}

    var isPullToRefreshLoading: Bool {get}
    var isLoadMoreLoading: Bool {get}
    var delegate: PaginationDelegate?{get}
    
    func addScrollViewOffsetObserver()
    func removeScrollViewOffsetObserver()
    func scrollViewWillEndDragging(_ scrollView: UIScrollView)
    func set(scrollView: UIScrollView)
    
    func update(pageInfo: PageInfo, isLoadMoreAvailable: Bool)
    func resetPageInfo() 
}

extension PaginationProvider {
    func update(pageInfo: PageInfo, isLoadMoreAvailable: Bool) {
        self.pageInfo = pageInfo
        self.isLoadMoreEnabled = self.pageInfo.loadNext && isLoadMoreAvailable
    }
    
    func resetPageInfo() {

    }
    
    func set(scrollView: UIScrollView) {
    }
}





