//
// Created by Apps AS on 19/03/16.
// Copyright (c) 2016 All rights reserved.
//

import Foundation
import UIKit

class ALPopTransitionAnimatorZoomOut: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate let transformedToViewSnapshot: UIView
    
    init(transformedToViewSnapshot: UIView) {
        self.transformedToViewSnapshot = transformedToViewSnapshot
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!;
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!;

        let bounds = transitionContext.containerView.bounds
        let frame = CGRect(x: 0, y: 44+20, width: bounds.size.width, height: bounds.size.height)
        toViewController.view.frame = frame

        let toZoomOutScale: CGFloat = 0.952;

        transitionContext.containerView.addSubview(transformedToViewSnapshot)
        transitionContext.containerView.sendSubviewToBack(transformedToViewSnapshot)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromViewController.view.transform = CGAffineTransform(scaleX: toZoomOutScale, y: toZoomOutScale)
            fromViewController.view.alpha = 0.0

            self.transformedToViewSnapshot.transform = CGAffineTransform.identity
        }, completion: { finished in
            transitionContext.containerView.addSubview(toViewController.view)
            self.transformedToViewSnapshot.removeFromSuperview()

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
