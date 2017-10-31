//
//  NavigationControllerDelegate.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC.isKind(of: PhotoDetailsViewController.self) {
            return NavigationTransition()
        //} else if fromVC.isKind(of: PhotoPreviewViewController.self) {
        //    return NavigationTransition()
        } else {
            return nil
        }
    }
    
}
