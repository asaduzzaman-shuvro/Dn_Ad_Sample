//
// Created by Apps AS on 24/02/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit
import WebKit
import NVActivityIndicatorView
import SwiftyJSON

class ArticleDetailViewController: UIViewController {

    @AutoLayoutView var webView: WKWebView!
    
    var delegate: ArticleDetailViewControllerDelegate?
    var pageIndex: Int = 0
    
    var loadingView: NVActivityIndicatorView!
    
    private var observation: NSKeyValueObservation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupWebView()
        self.loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150), type: NVActivityIndicatorType.circleStrokeSpin, color: .loadingSpinnercolor(), padding: 20)
        self.loadingView.center = CGPoint(x: UIScreen.main.bounds.width  / 2, y: (UIScreen.main.bounds.height / 2) - 50)
        self.view.addSubview(loadingView)
        self.loadingView.startAnimating()
    
        self.loadWebRequest()
        
        if self.webView.estimatedProgress < 1{
            self.observation = webView.observe(\.estimatedProgress, options: [.new]) { _, _ in
                if self.webView.estimatedProgress >= 0.6 {
                    self.endProgressAnimation()
                }
            }
        }else{
            self.endProgressAnimation()
        }
    }
    
    // Initialize WKWebView
    func setupWebView() {
        // setup preferences
        self.webView?.removeFromSuperview()
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = .audio
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "wineFeedbackAdded")
        
        webConfiguration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.scrollView.backgroundColor = UIColor.feedBackgroundColor()
        webView.scrollView.bounces = true
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        //set cookie
        let dataStore = WKWebsiteDataStore.default()
        dataStore.httpCookieStore.getAllCookies({ (cookies) in
            for cookie in cookies {
                self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
        })
        
        let userAgentValue = "DNApp/\("1.0.0") iOS"
        webView.evaluateJavaScript("navigator.userAgent") { [weak webView] (result, error) in
            if let webView = webView, let userAgent = result as? String {
                log(object: "userAgent \(userAgent)")
                webView.customUserAgent = userAgent + " \(userAgentValue)"
            }
        }
        
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        
        _webView.constraints = self.initConstraint(root: self.view, view: webView)
        
        // Initialize Refresh Control
        webView.scrollView.refreshControl = UIRefreshControl(frame: .zero)
        webView.scrollView.refreshControl?.tintColor = UIColor.shadesOfGrey09()
        webView.scrollView.refreshControl?.addTarget(self, action: #selector(ArticleDetailViewController.handleRefresh(_:)), for: .valueChanged)
        self.view.addSubview(webView)
        
        self.view.sendSubviewToBack(self.webView)
        // Activate Constraints
        NSLayoutConstraint.activate(_webView.constraints)
    }
    
    private func loadWebRequest() {
        // Load Request
        delegate?.getURLRequest({request in
            log(object: "ACPCORE request \(String(describing: request?.url?.absoluteString))")
            DispatchQueue.main.async {
                guard let urlRequest = request, let articleId = self.delegate?.article?.articleId else { return  }
                self.webView.load(urlRequest)
            }
        })
    }
    
    deinit {
        observation = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress >= 0.8 {
                self.endProgressAnimation()
//                self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        super.viewWillDisappear(animated)
    }
    
    func reload() {
        guard let articleId = self.delegate?.article?.articleId else { return }
        DispatchQueue.main.async {
            self.setupWebView()
            self.loadingView.startAnimating()
            self.loadWebRequest()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl?) {
        self.delegate?.getReloadUrlRequest({request in
            if let urlRequest = request {
                self.webView.load(urlRequest)
            }
        })
    }
}

extension ArticleDetailViewController {
    func initConstraint(root: UIView, view: UIView) -> [NSLayoutConstraint] {

        let viewConstraints =  [view.topAnchor.constraint(equalTo: root.safeTopAnchor),
                                view.leadingAnchor.constraint(equalTo: root.safeLeadingAnchor),
                                root.safeBottomAnchor.constraint(equalTo: view.bottomAnchor),
                                root.safeTrailingAnchor.constraint(equalTo: view.trailingAnchor)]
        
        return viewConstraints
    }
}

extension ArticleDetailViewController {
    // MARK: - ScrollView Delegate
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        
        if bottomEdge >= scrollView.contentSize.height {
            delegate?.articleReachedBottom()
        }
    }
}


extension ArticleDetailViewController: WKNavigationDelegate {
    // MARK: - WKWebView Navigation Delegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.endProgressAnimation()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.endProgressAnimation()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
//        self.endProgressAnimation()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        self.endProgressAnimation()
    }
    
    func endProgressAnimation() {
        DispatchQueue.main.async {
            self.loadingView?.stopAnimating()
            if let refreshControl = self.webView.scrollView.refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if DNWebUtil.sharedInstance.shouldAllowNavigationAction(url: navigationAction.request.url){
            switch navigationAction.navigationType {
                case .linkActivated:
                    delegate?.handleClick(for: navigationAction.request)
                    decisionHandler(.cancel)
                case .other:
                    if DNWebUtil.sharedInstance.shouldAllowOtherNavigationAction(url: navigationAction.request.url) {
                    
                        delegate?.handleClick(for: navigationAction.request)
                        decisionHandler(.cancel)
                    }else {
                        decisionHandler(.allow)
                    }
                default:
                    decisionHandler(.allow)
            }
        }else{
            decisionHandler(.cancel)
        }
    }
}

extension ArticleDetailViewController: UIScrollViewDelegate {

}

extension ArticleDetailViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
}
