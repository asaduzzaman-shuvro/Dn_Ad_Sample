//
//  VerticalPaginationManager.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 4/11/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

class VerticalPaginationManager: NSObject, VerticalPaginationProvider {
    var bottomMostLoaderContainerView: UIView?
    var bottomActivitiyIndicatorView: UIActivityIndicatorView?
    var bottomLoaderIndicatorColor: UIColor = UIColor.grayish2()
    
    var pageInfo: PageInfo = PageInfo()
    var isObservingKeyPath: Bool = false
    var isEnabled: Bool = false
    var isLoadMoreEnabled: Bool = false
    var scrollView: UIScrollView
    
    var isPullToRefreshLoading: Bool = false
    var isLoadMoreLoading: Bool = false
    var userInterationLoadMoreEnabled: Bool = false
    
    var delegate: PaginationDelegate?
    private let userInteractiveButton = UIButton()

    
    init(with scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init()
        self.setUpCommonSettings()
    }
    
    override init() {
        self.scrollView = UIScrollView()
        super.init()
    }
    
    convenience init(userInteractionLoadMoreEnabled: Bool = false) {
        self.init()
        self.userInterationLoadMoreEnabled = userInteractionLoadMoreEnabled
    }
    
    private func setUpCommonSettings() {
        self.scrollView.contentInset.bottom = 0
        self.addScrollViewOffsetObserver()
        self.addBottomMostLoder()
        self.addUserInteractiveButton()
    }
}

extension VerticalPaginationManager {
    
    func set(scrollView: UIScrollView) {
        self.scrollView = scrollView
        self.setUpCommonSettings()
    }
    
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
        let offsetY = offset.y

        guard self.isEnabled && self.isLoadMoreEnabled, offsetY > 0 else {
            return
        }
        let contentHeight = self.scrollView.contentSize.height
        let frameHeight = self.scrollView.bounds.size.height
        let diffY = contentHeight - frameHeight
      
        if contentHeight > frameHeight, offsetY > (contentHeight - frameHeight)  {
            self.bottomMostLoaderContainerView?.frame = CGRect(x: 0, y: contentHeight, width: scrollView.width, height: offsetY - diffY)
            if self.userInterationLoadMoreEnabled  {
                self.userInteractiveButton.isHidden = false
            } else {
                if !self.isLoadMoreLoading {
                    self.isLoadMoreLoading = true
                    self.bottomActivitiyIndicatorView?.startAnimating()
                    self.delegate?.loadMore(completion: { (isSuccess) in
                        self.isLoadMoreLoading = false
                        self.bottomActivitiyIndicatorView?.stopAnimating()
                    })
                }
            }
        }
    }
    
    func resetPageInfo() {
        self.isLoadMoreLoading = false
        self.pageInfo.reset()
    }
    
}

extension VerticalPaginationManager {
    
    func addUserInteractiveButton() {
        
        guard let bottomView = self.bottomMostLoaderContainerView, userInterationLoadMoreEnabled else {
            return
        }
        
        let font = UIFont.systemFont(ofSize: 14)
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.98
        paragraphStyle.alignment = .center


        let attributedText = NSMutableAttributedString(string: "Vis mer", attributes: [NSAttributedString.Key.kern: 0.2, NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.foregroundColor : UIColor.shadesOfBlue07(), NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue ])
        
        userInteractiveButton.setImage(UIImage(named: "icon_expand"), for: .normal)
//        userInteractiveButton.imageView?.setTint(color: UIColor.shadesOfBlue07())
        userInteractiveButton.semanticContentAttribute = .forceRightToLeft
        userInteractiveButton.translatesAutoresizingMaskIntoConstraints = false
        userInteractiveButton.addTarget(self, action: #selector(pressOnLoadMorButton(sender:)), for: .touchUpInside)
        userInteractiveButton.setAttributedTitle(attributedText, for: .normal)
        userInteractiveButton.isHidden = true
        userInteractiveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        self.bottomMostLoaderContainerView?.addSubview(userInteractiveButton)
        
        NSLayoutConstraint.activate([
            userInteractiveButton.centerXAnchor.constraint(equalTo: bottomView.safeCenterXAnchor),
            userInteractiveButton.centerYAnchor.constraint(equalTo: bottomView.safeCenterYAnchor, constant: self.loaderCenterConstraint),
        ])
    }
    
    @objc private func pressOnLoadMorButton(sender: UIButton) {
        sender.isHidden = true
        if !self.isLoadMoreLoading {
            self.isLoadMoreLoading = true
            self.bottomActivitiyIndicatorView?.startAnimating()
            self.delegate?.loadMore(completion: { (isSuccess) in
                DispatchQueue.main.async {
                    self.bottomActivitiyIndicatorView?.stopAnimating()
                    self.isLoadMoreLoading = false
                }
            })
        }
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView) {
//
//        guard isEnabled && isLoadMoreEnabled else {
//            return
//        }
//
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = self.scrollView.contentSize.height
//        let frameHeight = self.scrollView.bounds.size.height
//        if contentHeight > frameHeight, (offsetY - (contentHeight - frameHeight)) > 10 {
//            bottomActivitiyIndicatorView?.startAnimating()
//            if !isLoadMoreLoading {
//                self.delegate?.loadMore(completion: { (isSuccess) in
//                    self.removeBottomLoader()
//                    self.isLoadMoreLoading = !isSuccess
//                })
//            }
//        }
    }
}
