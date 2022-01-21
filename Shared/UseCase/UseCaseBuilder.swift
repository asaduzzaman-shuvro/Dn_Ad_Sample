//
//  UseCaseBuilder.swift
//  GoogleAdSample (iOS)
//
//  Created by Asaduzzaman Shuvro on 20/1/22.
//

import Foundation
import UIKit

class UseCaseBuilder {
    
    class func buildUpFront() -> UIViewController {
        let serviceProvider = DNNewsServiceProvider(pageType: .front, feedUrlString: "")
        let jsonResolver = FeedJSONResolver(pageType: .front, componentFactory: ComponentFactory())
        
        let partBuilder = AnyArticleSummaryPagePartBuilder<FrontArticleSummarySection>(partBuilder: ArticleSummaryPagePartBuilder(pageType: .front, viewInitialsFactory: ArticleSummaryPageViewInitialsFactory()))
        let controller = NewsFeedController<FrontArticleSummarySection>(pageType: .front, serviceProvider: serviceProvider, feedJSONResolver: jsonResolver, partBuilder: partBuilder, paginationManager: nil)
        let viewController = NewsFeedViewController()

        viewController.feedDelegate = controller
        controller.newsFeedViewContainer = viewController
        
        return UINavigationController(rootViewController: viewController)
    }
}
