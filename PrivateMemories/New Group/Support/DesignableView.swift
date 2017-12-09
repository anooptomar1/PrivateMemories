//
//  DesignableView.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 08.12.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

@IBDesignable public class DesignableView: UIView {
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            let bounds = layer.bounds
            let cgRect = CGRect(x: bounds.origin.x, y: shadowOffsetY + 3, width: bounds.width, height: bounds.height)
            layer.shadowPath = UIBezierPath(rect: cgRect).cgPath
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var degrees: Double = 0 {
        didSet {
            var transform = CATransform3DIdentity
            transform.m34 = -1.0/500
            let angle = CGFloat((degrees * Double.pi) / 180.0)
            let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
            layer.transform = rotation
        }
    }
    
    @IBInspectable public var perspective: CGFloat = 2500 {
        didSet {
            let degrees: Double = 50
            var transform = CATransform3DIdentity
            transform.m34 = -1.0/perspective
            let angle = CGFloat((degrees * Double.pi) / 180.0)
            let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
            layer.transform = rotation
        }
}
}
