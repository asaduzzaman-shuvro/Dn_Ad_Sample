//
// Created by Apps AS on 23/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class ArticleDetailController: ArticleDetailViewControllerDelegate {
    weak var viewController: ArticleDetailViewController?
    weak var editionPagerDelegate: EditionArticleNavigationDelegate?
    
    var article: ArticleDetailChunk?
    
    func getURLRequest(_ completion: @escaping (_ urlRequest: URLRequest?) -> Void){
        self.createURLRequest(cachePolicy: .reloadIgnoringLocalCacheData, {request in
            completion(request)
        })
    }
    
    func getReloadUrlRequest(_ completion: @escaping (_ urlRequest: URLRequest?) -> Void){
        self.createURLRequest(cachePolicy: .reloadIgnoringCacheData, {request in
            completion(request)
        })
    }
    
    func createURLRequest(cachePolicy: NSURLRequest.CachePolicy, _ completion: @escaping (_ urlRequest: URLRequest?) -> Void){
        if let publicLink = self.article?.publicLink{
            if let url = URL(string: publicLink){
                URLMapper.sharedInstance.appendVisitorInfoForUrl(url: url, {appendedUrl in
                    self.getProcessedURLRequest(url: appendedUrl, cachePolicy: cachePolicy, {request in
                        completion(request)
                    })
                })
            }else{
                completion(nil)
            }
        }
    }
    
    
    fileprivate func getProcessedURLRequest(url: URL, cachePolicy: NSURLRequest.CachePolicy, _ completion: @escaping (_ urlRequest: URLRequest?) -> Void){
        DNWebCookieManager.shouldAuthorizeWithRedirection({redirect in
            completion(URLRequest(url: url, cachePolicy: cachePolicy))
        })
    }
    
    func backButtonTapped() {
        editionPagerDelegate?.articleDetailBackPressed()
    }
    
    func shareArticle() {
        guard let article = self.article else {
            return
        }
        
        self.getArticleShareItems {[weak self] shareItems in
            guard self != nil else {
                return
            }
            
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityViewController.setValue(article.title, forKey: "subject")

                if let popOverViewController = activityViewController.popoverPresentationController,
                   let barItem = self?.viewController?.navigationItem.rightBarButtonItem {
                    popOverViewController.barButtonItem = barItem
                }

                self?.viewController?.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    func articleReachedBottom() {
        
    }
    
    func startWithNavigation() {
        
    }
    
    func handleClick(for urlRequest: URLRequest) {
        if let url = urlRequest.url {
            self.handleClick(for: url)
        }
    }
}

extension ArticleDetailController {
    func handleClick(for url: URL) {
        if let type = URLMapper.sharedInstance.getType(for: url) {
            switch type {
            case .dnWeb(let inherentType):
                switch inherentType {
                case .topic(let identifier):
                    self.navigateToTopic(identifier: identifier)
                case .purchase:
                    self.showServiceUnavailableAlert()
                case .articleGift:
                    self.showArticleGiftAlert()
                case .other:
                    self.navigateToArticleDetail(for: url.absoluteString)
                default:
                    break
                }
            case .nhstWeb(let inherentType):
                if inherentType.shouldOpenInside() {
                    self.showDisclaimerPage(source: url.absoluteString)
                } else {
                    url.openExternally()
                }
            case .investor:
                self.navigateToWebPage(for: URLMapper.sharedInstance.preprocessInvestorUrlString(url.absoluteString))
            case .web(let inherentType):
                if inherentType.shouldOpenInside() {
                    self.navigateToWebPage(for: url.absoluteString)
                } else {
                    url.openExternally()
                }
            case .email(let redirectURL), .phone(let redirectURL), .sms(let redirectURL):
                redirectURL.openExternally()
            default:
                self.navigateToWebPage(for: url.absoluteString)
            }
        }
    }
}

extension ArticleDetailController {
    func pushViewController(_ pushedViewController: UIViewController, animated: Bool) {
        if let viewController = self.viewController, let navigationController = viewController.navigationController {
            navigationController.pushViewController(pushedViewController, animated: animated)
        }
    }
    
    private func showDisclaimerPage(source: String) {
    }
    
    fileprivate func navigateToWebPage(for urlString: String) {
    }
    
    fileprivate func navigateToTopic(identifier: String) {
    }
    
    fileprivate func navigateToArticleDetail(for urlString: String) {
       
    }
    
    fileprivate func showServiceUnavailableAlert() {
       
    }
    
    private func showArticleGiftAlert() {
      
    }
}

// MARK: - VideoViewControllerDelegate
extension ArticleDetailController {
    func getArticleShareItems(completion: @escaping (_ shareItems: [AnyObject]) -> Void) {
        guard let sharedArticle = article else {
            return completion([])
        }
       
    }
    
    func getVideoSharingItems() -> [AnyObject] {
        return []
    }
}


