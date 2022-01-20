//
//  VerticalPaginationProvider.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 4/11/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol VerticalPaginationProvider: BottomPaginationProvider {
    
}

protocol BottomPaginationProvider: PaginationProvider {
    var userInterationLoadMoreEnabled: Bool {get}
    var bottomMostLoaderContainerView: UIView?{get set}
    var bottomActivitiyIndicatorView: UIActivityIndicatorView? {get set}
    var bottomLoaderIndicatorColor: UIColor {get set}
    func addBottomMostLoder()
    func removeBottomLoader(completion: (() -> Void)?)
}

extension BottomPaginationProvider {
    
    var loaderCenterConstraint: CGFloat {
        return userInterationLoadMoreEnabled ? -20 : 0
    }
    
    func addBottomMostLoder() {
        guard self.bottomMostLoaderContainerView == nil else {
            return
        }
        let view = UIView()
        view.frame.origin = CGPoint(x: 0, y: scrollView.contentSize.height)
        view.frame.size = CGSize(width: scrollView.frame.width, height: 0)
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = bottomLoaderIndicatorColor
        activityIndicator.frame = CGRect.zero
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeCenterYAnchor,constant: loaderCenterConstraint),
        ])
        
        self.bottomActivitiyIndicatorView = activityIndicator
        self.bottomMostLoaderContainerView = view
        self.scrollView.addSubview(view)
    }

    func removeBottomLoader(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.bottomActivitiyIndicatorView?.removeFromSuperview()
            self.bottomActivitiyIndicatorView = nil
            self.bottomActivitiyIndicatorView?.removeFromSuperview()
            self.bottomActivitiyIndicatorView = nil
            UIView.animate(withDuration: 0.4) {
                self.scrollView.contentInset.bottom = 0
            }
        }
    }
}

