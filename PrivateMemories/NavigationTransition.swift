//
//  NavigationTransition.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 31.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class NavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            //let sourceViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let destinationViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            //let sourceView = sourceViewController.view,
            let destinationView = destinationViewController.view
        else { return }
    
        let containerView = transitionContext.containerView
        
        //containerView.addSubview(sourceView)
        containerView.addSubview(destinationView)
        
        // Initial values before animation
        
        destinationView.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            destinationView.alpha = 1.0
        }) {_ in
            transitionContext.completeTransition(true)
        }
    }
    

    
}
