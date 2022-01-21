//
//  EditionArticlesDelegate.swift
//  DNApp
//
//  Created by Ashif Iqbal on 11/29/16.
//  Copyright © 2016 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol EditionArticlesDelegate: AnyObject {
    
    func queryStyleForArticle(articleId: String) -> ArticleStyle?
}

protocol EditionArticleNavigationDelegate: AnyObject {
    
    func articleDetailBackPressed()
    func getPaymentCallerController() -> UIViewController
    func shouldDisplayPaywallForArticle(articleId: String) -> Bool
    func addArticleTrackingForDisplayedArticle(article: Article, pageIndex: Int)
}

