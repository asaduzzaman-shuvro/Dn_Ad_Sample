//
//  BaseNewsFeedController.swift
//  DNApp
//
//  Created by Nahidul Islam Raffi on 28/6/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BaseNewsFeedController<SectionType>: NewsFeedViewControllerDelegate, PaginationDelegate {
    
    weak var newsFeedViewContainer: NewsFeedContainerViewType?
    
    let pageType: PageType
    let feedJSONResolver: FeedJSONResolver
    let partBuilder: AnyArticleSummaryPagePartBuilder<SectionType>
    var components: [Component] = []
    var previouslyTappedArticleId: String?
    
//    var lifeCycleState: LifeCycleState?
    
    var paginationManger: VerticalPaginationManager?
    
    init(pageType: PageType, feedJSONResolver: FeedJSONResolver, partBuilder: AnyArticleSummaryPagePartBuilder<SectionType>, paginationManager: VerticalPaginationManager? = nil) {
        self.pageType = pageType
        self.feedJSONResolver = feedJSONResolver
        self.partBuilder = partBuilder
        self.paginationManger = paginationManager
    }
    
    func buildUpParts(completion: @escaping (_ sections: [CollectionViewSectionInfoProviding]) -> Void, onError: @escaping (_ error: Error?) -> Void) {}
    
    func start() {
        self.newsFeedViewContainer?.startProgressAnimation()
        
        self.buildUpParts(completion: { [weak self] sections in
            self?.newsFeedViewContainer?.reload(with: sections)
            self?.newsFeedViewContainer?.stopProgressAnimation()
            self?.newsFeedViewContainer?.hideEmptyErrorView()
        }, onError: { [weak self] error in
            if let error = error {
                self?.handleFeedError(error)
            }
            self?.newsFeedViewContainer?.stopProgressAnimation()
        })
    }
    
    func refresh(pullToRefresh: Bool) {
        self.clearCache()
        
        guard pullToRefresh else {
            self.start()
            return
        }
        self.paginationManger?.resetPageInfo()
        self.refreshData()
    }
    
    func refetchDataForError() {
        self.clearCache()
        refreshData(withShowingProgressBar: true)
    }
    
    private func clearCache() {
        DFPAdManager.sharedInstance.clear()
//        DNWebViewManager.sharedInstance.clearFeedPagesCache()
//        DnLiveVideoManager.shared.clear()
    }
    
    private func refreshData(withShowingProgressBar shouldShow: Bool = false) {
        if shouldShow {
            self.newsFeedViewContainer?.startProgressAnimation()
        }
    
        self.buildUpParts(completion: { [weak self] sections in
            self?.newsFeedViewContainer?.reload(with: sections)
            self?.newsFeedViewContainer?.hideEmptyErrorView()
            self?.newsFeedViewContainer?.endRefreshing()
            self?.newsFeedViewContainer?.stopProgressAnimation()
        }, onError: {[weak self] error in
            self?.newsFeedViewContainer?.endRefreshing()
            if let error = error {
                self?.handleFeedError(error)
            }
        })
    }
    
    func performPendingOperation() {}
    
    func partSelected(_ part: CollectionViewFeedPart) {
//        if let part = part as? ArticleSummaryPart {
//            self.previouslyTappedArticleId = part.articleId
//            self.showArticleById(part.articleId)
//        }
    }
    
    
    
    //*************************************************
    //MARK:- Pagination Actions
    //*************************************************
    
    func setUpPagination() {
        guard let paginationManager = self.paginationManger, let collectionView = self.newsFeedViewContainer?.getCollectionView()  else {
            return
        }
        paginationManager.set(scrollView: collectionView)
        paginationManager.delegate = self
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView) {
        paginationManger?.scrollViewWillEndDragging(scrollView)
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        
    }
    
    func updatePageInfo(for pageFeed: PagedFeed) {
        guard let paginationManger = self.paginationManger else {
            return
        }
        self.paginationManger?.isEnabled = true
        self.paginationManger?.update(pageInfo: PageInfo(withCurrentPage: paginationManger.pageInfo.currentPage + 1, totalItems: pageFeed.totalContentCount, size: pageFeed.newContentCount, offset: pageFeed.currentOffset), isLoadMoreAvailable: true)
    }
}

extension BaseNewsFeedController {
    func handleFeedError(_ error: Error?) {
        self.newsFeedViewContainer?.showEmptyState(with: ErrorStateMapper.shared.getViewModel(for: error?.extractErrorType()))
        self.newsFeedViewContainer?.stopProgressAnimation()
        
    }
    
    func pushViewController(_ pushedViewController: UIViewController, animated: Bool) {
        if let viewController = self.newsFeedViewContainer as? UIViewController, let navigationController = viewController.navigationController {
            DispatchQueue.main.async {
                navigationController.pushViewController(pushedViewController, animated: animated)
            }
        }
    }
    
    func presentOnTabbarConroller(_ viewController: UIViewController, animated: Bool) {
       
    }
    
    func presentViewController(_ viewController: UIViewController, animated: Bool, completion:(() -> Void)?) {
        guard let presentingViewController = self.newsFeedViewContainer as? UIViewController else {
            return
        }
        
        DispatchQueue.main.async {
            (presentingViewController.navigationController ?? presentingViewController).present(viewController, animated: animated, completion: completion)
        }
    }
    
    func open(_ urlString: String) {
        if let url = URL(string: urlString) {
            self.open(url)
        }
    }
    
    func open(_ url: URL) {
//        if let type = URLMapper.sharedInstance.getType(for: url) {
//            switch type {
//            case .web(let inherentType):
//                if inherentType.shouldOpenInside() {
//                    self.navigateToWebPage(for: url.absoluteString)
//                } else {
//                    url.openExternally()
//                }
//            case .investor:
//                self.navigateToWebPage(for: URLMapper.sharedInstance.preprocessInvestorUrlString(url.absoluteString))
//            case .email(let redirectURL), .phone(let redirectURL), .sms(let redirectURL):
//                redirectURL.openExternally()
//            default:
//                self.navigateToWebPage(for: url.absoluteString)
//            }
//        }
    }
}

// MARK: - Dynamic Content Cell Delegate
// MARK: - EditingContainerDynamicContentCellDelegate
extension BaseNewsFeedController {
    func adjustHeightForDynamicContent(at indexPath: IndexPath, height: CGFloat) {
        DispatchQueue.main.async {
            if height == .zero {
                self.newsFeedViewContainer?.removeItem(at: indexPath)
                self.newsFeedViewContainer?.performUpdates()
            }else {
                self.newsFeedViewContainer?.adjustHeightForDynamicContent(at: indexPath, height: height)
            }
        }
    }
    
    func adjustHeightForDynamicContent(cell: UICollectionViewCell, height: CGFloat) {
        guard let indexPath = self.newsFeedViewContainer?.getIndexPath(for: cell) else {
            return
        }
        
        self.adjustHeightForDynamicContent(at: indexPath, height: height)
    }
}

//MARK: - AdComponentDelegate
extension BaseNewsFeedController {
    func getRootViewController() -> UIViewController? {
        return self.newsFeedViewContainer as? UIViewController
    }
    
    func cacheAdView(adViewIdentifier: String, bannerView: GADBannerView, adFailed: Bool) {
        DFPAdManager.sharedInstance.cacheView(adViewIdentifier: adViewIdentifier, dfpBannerView: bannerView, adFailed: adFailed)
    }
    
    func fetchAdView(adViewIdentifier: String) -> DFPAdView? {
        return DFPAdManager.sharedInstance.fetchView(adViewIdentifier: adViewIdentifier)
    }
}

//MARK: - SearchableContentDelegate
//MARK: - SearchViewPresentingController
extension BaseNewsFeedController {
    func showSearchPage() {
//        AdobeEventsManager.sharedInstance.trackAction(event: DN_search_selected)
//        let searchViewController = UseCaseBuilder.buildUpSearchViewController(presentingController: self)
//        searchViewController.modalPresentationStyle = .overFullScreen
//        searchViewController.modalPresentationCapturesStatusBarAppearance = true
//        self.presentViewController(searchViewController, animated: false, completion: nil)
    }
    
    func dismissSearchView(_ viewController: UIViewController) {
        viewController.dismiss(animated: false, completion: nil)
    }
    
    func showSearchResultViewController(withQuery string: String) {
//        let searchResultViewController = UseCaseBuilder.buildUpSearchResultViewController(presetQuery: string)
//        self.pushViewController(searchResultViewController, animated: true)
    }
}

extension BaseNewsFeedController {
    func navigateToWebPage(for urlString: String) {
//        let webPage = UseCaseBuilder.buildUpWebViewController(sourceUrlString: urlString, hierarchicalType: .pushed)
//        self.pushViewController(webPage, animated: true)
    }
    
    func navigateToTopicPage(topicIdentifier: String, topicName: String) {
//        let topicViewController = UseCaseBuilder.buildUpTopicFeed(topicIdentifier: topicIdentifier, topicName: topicName)
//        self.pushViewController(topicViewController, animated: true)
    }
}

extension BaseNewsFeedController {
//    func getArticleSummaries() -> [ArticleSummaryType] {
//        var articleSummaries: [ArticleSummaryType] = [ArticleSummaryType]()
//        for case let articleSummary as ArticleSummaryType in components {
//            if !articleSummaries.contains(where: { $0.id == articleSummary.id }) && !articleSummary.id.hasPrefix("_null_id") {
//                articleSummaries.append(articleSummary)
//            }
//        }
//        return articleSummaries
//    }
    
    fileprivate func showArticleById(_ articleId: String) {
//        let articleSummaries = self.getArticleSummaries()
//
//        guard articleId != "" && articleSummaries.count > 0 else {
//            return
//        }
//
//        let selectedIndex = articleSummaries.firstIndex(where: { $0.id == articleId }) ?? 0
//
//        let summary = articleSummaries[selectedIndex]
//        log(object: "Showing Article: articleUrl# \(summary.publicUrl)")
//        self.navigateForTeaser(articleSummary: summary, urlString: summary.publicUrl)
    }
}

//MARK: - GeneralNavBarButtonActionHandler
//extension BaseNewsFeedController: FrontPageNavBarButtonActionHandler {
//    func showNewsletterPage() {
////        AdobeEventsManager.sharedInstance.trackAction(event: DN_Newsletter_View_Selected)
////        let newsletterViewController = UseCaseBuilder.buildUpNewsletterSummaryViewController()
////        self.pushViewController(newsletterViewController, animated: false)
//    }
//}

//MARKL:- NavigationForArticleTeasers
//extension BaseNewsFeedController{
//    func navigateForTeaser(articleSummary: ArticleSummaryType, urlString: String){
////        let articleSummaryUrl = SettingsManager.sharedInstance.forceLoadArticle.shouldLoadArticle ?
////            SettingsManager.sharedInstance.forceLoadArticle.articleUrl :
////            articleSummary.publicUrl
////
////        let webType = DNWebUtil.sharedInstance.getType(for: articleSummaryUrl)
////        if webType.type == .article {
////            let articleDetailChunk: ArticleDetailChunk = SettingsManager.sharedInstance.forceLoadArticle.shouldLoadArticle ? ArticleDetailChunk.build(publicLink: SettingsManager.sharedInstance.forceLoadArticle.articleUrl) :
////                ArticleDetailChunk.build(summary: articleSummary)
////
////            let articleDetail = UseCaseBuilder.buildUpArticleDetailController(articleDetail: articleDetailChunk, hierarchicalType: .pushed)
////            self.pushViewController(articleDetail.viewController, animated: true)
////        }else{
////            self.open(articleSummaryUrl)
////        }
//    }
//}
