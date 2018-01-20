//
//  UIViewControllerExtension.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 20.01.2018.
//  Copyright © 2018 Krzysztof Babis. All rights reserved.
//

import UIKit

extension UIViewController {
    func animateSliding(constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 2.0) {
            constraint.constant = 0
        }
    }
}
