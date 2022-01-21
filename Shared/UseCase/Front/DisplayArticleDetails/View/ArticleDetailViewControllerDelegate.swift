//
// Created by Apps AS on 28/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation

protocol ArticleDetailViewControllerDelegate : AnyObject {
    var viewController: ArticleDetailViewController? {get set}
    
    var article: ArticleDetailChunk? {get set}
    
    func getURLRequest(_ completion: @escaping (_ urlRequest: URLRequest?) -> Void)
    func getReloadUrlRequest(_ completion: @escaping (_ urlRequest: URLRequest?) -> Void)
    func articleReachedBottom()
    func startWithNavigation()
    func handleClick(for urlRequest: URLRequest)
}
