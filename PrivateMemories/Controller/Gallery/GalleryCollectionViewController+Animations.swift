//
//  GalleryViewController+Animations.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 22.01.2018.
//  Copyright © 2018 Krzysztof Babis. All rights reserved.
//

import UIKit

extension GalleryCollectionViewController {
    
    func setEditingMode(active: Bool) {
        let imageName = active ? "cancel" : "edit"
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.sortButton.transform = active ? CGAffineTransform(translationX: 0, y: 100) : CGAffineTransform.identity
            self.addButton.transform = active ? CGAffineTransform(translationX: 0, y: 100) : CGAffineTransform.identity
            self.editButton.setImage(UIImage(named: imageName), for: .normal)
        })
    }
    
    func setAddingMode(active: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.0 , usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: { () -> Void in
            if active {
                self.addButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
                self.sortButton.transform = CGAffineTransform(translationX: -200, y: 0.0)
                self.editButton.transform = CGAffineTransform(translationX: 200, y: 0.0)
            } else {
                self.galleryButton.transform = CGAffineTransform.identity
                self.cameraButton.transform = CGAffineTransform.identity
                self.addButton.transform = .identity
            }
        })
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            if active {
                self.galleryButton.transform = CGAffineTransform(translationX: 150, y: 0.0)
                self.cameraButton.transform = CGAffineTransform(translationX: -150, y: 0.0)
            } else {
                self.sortButton.transform = CGAffineTransform.identity
                self.editButton.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
    
}
