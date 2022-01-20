//
//  HorizontalPaginationProvider.swift
//  DNApp
//
//  Created by Asaduzzaman Shuvro on 4/11/20.
//  Copyright © 2020 no.dn.dn. All rights reserved.
//

import Foundation
import UIKit

protocol HorizontalPaginationProvider:  HorizontalRightProvider {
}

//*************************************************
//MARK:- Horizontal Left Provider
//*************************************************

protocol HorizontalLeftProvider : PaginationProvider {
    var leftMostLoaderContainerView: UIView?{get set}
    var leftActivitiyIndicatorView: UIActivityIndicatorView? {get set}
    var leftLoaderIndicatorColor: UIColor {get set}
    func addLeftMostControl()
    func removeLeftLoader()
}

extension HorizontalLeftProvider {
    func addLeftMostControl() {
        guard self.leftMostLoaderContainerView == nil else { return }
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame.origin = CGPoint(x: 0, y: 0)
        view.frame.size = CGSize(width: 0, height: self.scrollView.bounds.height)
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.color = leftLoaderIndicatorColor
        activityIndicator.frame = CGRect.zero
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.leftActivitiyIndicatorView = activityIndicator
        self.leftMostLoaderContainerView = view
        self.scrollView.addSubview(view)

    }
    
    func removeLeftLoader() {
        DispatchQueue.main.async {
            self.leftActivitiyIndicatorView?.removeFromSuperview()
            self.leftActivitiyIndicatorView = nil
            self.leftMostLoaderContainerView?.removeFromSuperview()
            self.leftMostLoaderContainerView = nil
            
            UIView.animate(withDuration: 0.4) {
                self.scrollView.contentInset.left = 0
                self.scrollView.setContentOffset(.zero, animated: true)
            }
        }
    }
}


//*************************************************
//MARK:- Horizontal Right provider
//*************************************************
protocol HorizontalRightProvider : HorizontalLeftProvider {
    var rightMostLoaderContainerView: UIView? {get set}
    var rightActivitiyIndicatorView: UIActivityIndicatorView? {get set}
    var rightLoaderIndicatorColor: UIColor{get set}
    func addRightMostControl()
    func removeRightLoader()
}

extension HorizontalRightProvider {
    func addRightMostControl() {
       
       guard self.rightMostLoaderContainerView == nil else {
           return
       }
       
       let view = UIView()
       view.frame.origin = CGPoint(x: scrollView.contentSize.width,
                                   y: 0)
       view.frame.size = CGSize(width: 0,
                                height: scrollView.bounds.height)
       let activity = UIActivityIndicatorView(style: .whiteLarge)
       activity.color = self.rightLoaderIndicatorColor
       activity.hidesWhenStopped = true
       activity.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(activity)
       
       NSLayoutConstraint.activate([
           activity.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
       ])
       
       scrollView.addSubview(view)
       rightMostLoaderContainerView = view
       rightActivitiyIndicatorView = activity
   }
   
   func removeRightLoader() {
       DispatchQueue.main.async {
           self.rightActivitiyIndicatorView?.removeFromSuperview()
           self.rightActivitiyIndicatorView = nil
           self.rightMostLoaderContainerView?.removeFromSuperview()
           self.rightMostLoaderContainerView = nil
           self.scrollView.contentInset.right = 0
       }
   }
}



