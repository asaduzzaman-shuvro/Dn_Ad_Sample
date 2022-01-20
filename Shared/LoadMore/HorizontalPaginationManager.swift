//
//  HorizontalPaginationManager.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 4/11/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class HorizontalPaginationManager: NSObject,HorizontalPaginationProvider {
    var isPullToRefreshLoading = false
    var isLoadMoreLoading = false
    var isObservingKeyPath: Bool = false
   
    var scrollView: UIScrollView
    
    var leftMostLoaderContainerView: UIView?
    var leftActivitiyIndicatorView: UIActivityIndicatorView?
    var leftLoaderIndicatorColor: UIColor = UIColor.grayish2()
    
    var isEnabled: Bool = false
    var isLoadMoreEnabled: Bool = false
    
    var pageInfo: PageInfo = PageInfo()
    
    var rightMostLoaderContainerView: UIView?
    var rightActivitiyIndicatorView: UIActivityIndicatorView?
    var rightLoaderIndicatorColor: UIColor = UIColor.grayish2()

    weak var delegate: PaginationDelegate?
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init()
        self.scrollView.bounces = true
        self.removeAll()
        self.addScrollViewOffsetObserver()
        self.addRightMostControl()
    }

    deinit {
        self.removeScrollViewOffsetObserver()
    }
    
    func removeAll() {
        self.removeLeftLoader()
//        self.removeRightLoader()
    }
    
    func resetPageInfo() {
        self.isPullToRefreshLoading = false
        self.isLoadMoreLoading = false
        self.pageInfo.reset()
        self.rightActivitiyIndicatorView?.stopAnimating()
    }
    
}

extension HorizontalPaginationManager {
    func addScrollViewOffsetObserver() {
        if self.isObservingKeyPath { return }
        self.scrollView.addObserver(
            self,
            forKeyPath: "contentOffset",
            options: [.new],
            context: nil
        )
        self.isObservingKeyPath = true
    }
    
    func removeScrollViewOffsetObserver() {
        if self.isObservingKeyPath {
            self.scrollView.removeObserver(self,
                                           forKeyPath: "contentOffset")
        }
        self.isObservingKeyPath = false
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard let object = object as? UIScrollView,
            let keyPath = keyPath,
            let newValue = change?[.newKey] as? CGPoint,
            object == self.scrollView, keyPath == "contentOffset" else { return }
        self.setContentOffSet(newValue)
    }
    
    private func setContentOffSet(_ offset: CGPoint) {
        guard self.isEnabled else {
            return
        }
        let offsetX = offset.x
        if offsetX < 0 {
            self.addLeftMostControl()
            let width = abs(offsetX)
            self.leftMostLoaderContainerView?.frame = CGRect(x: offsetX, y: 0, width: width, height: self.scrollView.frame.height)
            self.leftActivitiyIndicatorView?.isHidden = false
            return
        } else {
            self.leftActivitiyIndicatorView?.isHidden = true
        }
        
        guard isLoadMoreEnabled else {
            return
        }
        
        let contentWidth = self.scrollView.contentSize.width
        let frameWidth = self.scrollView.bounds.size.width
        let diffX = contentWidth - frameWidth
        
        if contentWidth > frameWidth, offsetX > (contentWidth - frameWidth) {
            self.rightMostLoaderContainerView?.frame = CGRect(x: contentWidth, y: 0, width: offsetX - diffX, height: scrollView.frame.height)
            
            guard !self.isLoadMoreLoading else {
                return
            }
            self.isLoadMoreLoading = true
            self.rightActivitiyIndicatorView?.startAnimating()
            self.rightMostLoaderContainerView?.isHidden = false
            scrollView.contentInset.right = 60
            self.delegate?.loadMore(completion: { (isSuccess) in
                self.rightActivitiyIndicatorView?.stopAnimating()
                self.rightMostLoaderContainerView?.isHidden = true
                self.isLoadMoreLoading = false
            })
        }
    }
}

extension HorizontalPaginationManager {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView) {
        
        guard self.isEnabled else {
            return
        }
        
        let offsetX = scrollView.contentOffset.x
        
        // for left loader
        if offsetX < 0 {
            if offsetX < -80 {
                self.updateLeftView(with: 50)
                self.leftActivitiyIndicatorView?.startAnimating()
                self.firePullToRefreshDelegate()
            } else {
                self.updateLeftView(with: 0)
                self.leftActivitiyIndicatorView?.stopAnimating()
            }
        } else {
            self.updateLeftView(with: 0)
            self.leftActivitiyIndicatorView?.stopAnimating()
        }
        
        guard isLoadMoreEnabled else {
            return
        }
//        let contentWidth = scrollView.contentSize.width
//        let frameWidth = scrollView.bounds.size.width
//        let diffX = contentWidth - frameWidth
//
//        if contentWidth > frameWidth, offsetX > (diffX - 50) {
//            self.rightActivitiyIndicatorView?.startAnimating()
//            scrollView.contentInset.right = 60
//            if !self.isLoadMoreLoading {
//                self.isLoadMoreLoading = true
//                self.delegate?.loadMore(completion: { (isSuccess) in
//                    self.removeRightLoader()
//                    self.isLoadMoreLoading = !isSuccess
//                })
//            }
//        }
    }
    
    private func firePullToRefreshDelegate() {
        if !self.isPullToRefreshLoading {
            self.isPullToRefreshLoading = true
            self.delegate?.refreshAll(completion: { (isSuccess) in
                self.isPullToRefreshLoading = !isSuccess
                self.removeLeftLoader()
            })
        }
    }
    
    private func updateLeftView(with width: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.leftMostLoaderContainerView?.width = width
            self.scrollView.contentInset.left = width
        }
    }
}
