//
//  PhotoPreviewViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {
    
    @IBOutlet weak var presentedImageView: UIImageView!
    var presentedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        setImage()
        provideGestureRecognizing()
    }
    
    func setImage() {
        if let image = presentedImage {
            presentedImageView.image = image
        }
    }
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func dismissWithFade() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func handleTapGesture() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        dismissWithFade()
    }
    
    func provideGestureRecognizing() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        singleTapGesture.numberOfTapsRequired = 1
        presentedImageView.isUserInteractionEnabled = true
        presentedImageView.addGestureRecognizer(singleTapGesture)
    }
}
