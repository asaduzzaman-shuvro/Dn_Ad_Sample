//
//  ALPushTransitionAnimatorZoomIn.swift
//  CustomPushTransition
//
//  Created by ALi.apps.no on 19/03/16.
//  Copyright © 2016 no.apps. All rights reserved.
//

import Foundation
import UIKit

class ALPushTransitionAnimatorZoomIn: NSObject, UIViewControllerAnimatedTransitioning {
    
    let statusBarBackgroundColor: UIColor
    let transformationCompleted: (_ transformedSnapshotFromView: UIView) -> Void
    
    init(statusBarBackgroundColor: UIColor, transformationCompleted: @escaping (_ transformedSnapshotFromView: UIView) -> Void) {
        self.statusBarBackgroundColor = statusBarBackgroundColor
        self.transformationCompleted = transformationCompleted
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        let fromSnapshot = takeSnapshotFromScreenWithoutStatusBar()

        let toZoomInScale: CGFloat = 0.75;
        let fromZoomScale: CGFloat = 1.05;

        transitionContext.containerView.addSubview(fromSnapshot)
        toViewController.view.frame = transitionContext.containerView.bounds
        transitionContext.containerView.addSubview(toViewController.view)

        toViewController.view.transform = CGAffineTransform(scaleX: toZoomInScale, y: toZoomInScale)
        toViewController.view.alpha = 0.0

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toViewController.view.transform = CGAffineTransform.identity
            toViewController.view.alpha = 1.0

            fromSnapshot.transform = CGAffineTransform(scaleX: fromZoomScale, y: fromZoomScale)
        }, completion: { finished in
            fromSnapshot.removeFromSuperview()
            self.transformationCompleted(fromSnapshot)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    func takeSnapshotFromScreenWithoutStatusBar() -> UIView {
        let screenSnapshoot = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let statusBarBackgroundView = UIView(frame: CGRect(x: 0,y: 0,width: screenSnapshoot.bounds.width, height: 20))
        statusBarBackgroundView.backgroundColor = statusBarBackgroundColor
        screenSnapshoot.addSubview(statusBarBackgroundView)

        return screenSnapshoot
    }
}
