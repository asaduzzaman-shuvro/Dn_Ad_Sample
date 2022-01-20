//
//  NewsFeedController.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 30/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsFeedController<SectionType>: BaseNewsFeedController<SectionType> {
    typealias SectionType = SectionType
    
    let serviceProvider: DNNewsServiceProvider
    
    fileprivate var shouldReloadExistingDataAfterUserChange: Bool = false
    fileprivate var shouldRefreshData: Bool = false
    
    
    
    init(pageType: PageType, serviceProvider: DNNewsServiceProvider, feedJSONResolver: FeedJSONResolver, partBuilder: AnyArticleSummaryPagePartBuilder<SectionType>, paginationManager: VerticalPaginationManager? = nil) {
        self.serviceProvider = serviceProvider
        
        super.init(pageType: pageType, feedJSONResolver: feedJSONResolver, partBuilder: partBuilder,paginationManager: paginationManager)
        self.partBuilder.adComponentDelegate = self
        self.partBuilder.webContentViewCellDelegate = self
        
//        NotificationCenter.default.addObserver(self, selector: #selector(NewsFeedController.userHasChanged(_:)), name: Notification.Name(rawValue: UseCaseNotification.UserHasChanged), object: nil)
    }
    
    @objc func userHasChanged(_ sender: NSNotification) {
        self.newsFeedViewContainer?.reload()
    }
    
    override func buildUpParts(completion: @escaping (_ sections: [CollectionViewSectionInfoProviding]) -> Void, onError: @escaping (_ error: Error?) -> Void) {
        // use this for hot topics check.
//        dummyJsonBuilder { (sections) in
//            completion(sections)
//        }
        
        serviceProvider.requestNewsFeedAndCacheAsync(withPageInfo: self.paginationManger?.pageInfo, { [weak self] cachedJSON, json, error in
            guard let strSelf = self, let viewController = self?.newsFeedViewContainer, error == nil else {
                onError(error)
                return
            }

            let usableJSON = json ?? cachedJSON!

            let pagedFeed = strSelf.feedJSONResolver.resolvePagedJSON(usableJSON)

            strSelf.components = pagedFeed.components
            strSelf.paginationManger?.isEnabled = true
            strSelf.updatePageInfo(for: pagedFeed)
            let sections = strSelf.partBuilder.buildUpParts(components: strSelf.components, bounds: viewController.getCollectionViewBounds(), scrollDirection: viewController.getCollectionViewScrollDirection())
            completion(sections)
            }, onError: { error in
                onError(error)
        })
    }
    
    override func start() {
        self.newsFeedViewContainer?.startProgressAnimation()
        
        self.buildUpParts(completion: { [weak self] sections in
            self?.newsFeedViewContainer?.reload(with: sections)
            self?.newsFeedViewContainer?.stopProgressAnimation()
//            UseCaseNotification.send(UseCaseNotification.NewsFeedFetched, simpleData: nil)
            }, onError: {[weak self] error in
                self?.handleFeedError(error)
//                UseCaseNotification.send(UseCaseNotification.NewsFeedFetched, simpleData: nil)
        })
        
        setUpPagination()
    }
  
    
    override func performPendingOperation() {
        if self.shouldRefreshData {
            self.shouldRefreshData = false
            self.refresh(pullToRefresh: false)
            return
        }
        
        if self.shouldReloadExistingDataAfterUserChange {
            self.shouldReloadExistingDataAfterUserChange = false
            self.newsFeedViewContainer?.reload()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func dummyJsonBuilder(completion: @escaping (_ sections: [CollectionViewSectionInfoProviding]) -> Void) {
        guard let viewController = self.newsFeedViewContainer, let json = loadDummySpecialBlock() else {
            return
        }
        
        self.components = feedJSONResolver.resolveJSON(json).components
        
        let sections = partBuilder.buildUpParts(components: self.components, bounds: viewController.getCollectionViewBounds(), scrollDirection: viewController.getCollectionViewScrollDirection())
        
        completion(sections)
    }
    
    private func loadDummySpecialBlock() -> JSON?{
        if let path = Bundle.main.path(forResource: "specialBlock", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSON(data: data, options: .allowFragments)
                return jsonResult
            } catch {
                log(object: "jsonLoadError: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    override func loadMore(completion: @escaping (Bool) -> Void) {
        serviceProvider.requestNewsFeedAndCacheAsync(withPageInfo: self.paginationManger?.pageInfo) { [weak self]  (cachedJSON, json, error) in
            DispatchQueue.main.async {
                guard let strSelf = self, let viewController = self?.newsFeedViewContainer, error == nil, let lastCellIndexPath = viewController.getLastCell() else {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                    return
                }
                completion(true)
             
                let usableJSON = json ?? cachedJSON!
                
                let pagedFeed = strSelf.feedJSONResolver.resolvePagedJSON(usableJSON)
                strSelf.components.append(contentsOf: pagedFeed.components)
                strSelf.updatePageInfo(for: pagedFeed)
                let sections = strSelf.partBuilder.buildUpParts(components: pagedFeed.components, bounds: viewController.getCollectionViewBounds(), scrollDirection: viewController.getCollectionViewScrollDirection())
                let parts = sections.flatMap({$0.getContents()})
                viewController.insert(parts: parts, startingAt: lastCellIndexPath)
                viewController.performUpdates()
            }
        } onError: { (error) in
            DispatchQueue.main.async {
                completion(true)
            }
        }

    }
}


