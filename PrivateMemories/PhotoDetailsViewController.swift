//
//  PhotoDetailsViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: IB Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    //MARK: Properties
    
    var selectedPhotoIndexPath: IndexPath?
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provideGestureRecognizing()
        
        if let indexPath = selectedPhotoIndexPath {
            let selectedModelObject = model.posts[indexPath.row]
            selectedImage = UIImage(named: selectedModelObject["image"]!)
            photoImageView.image = selectedImage
            likesLabel.text = "♥ \(selectedModelObject["likes"]!) likes"
            postLabel.text = selectedModelObject["description"]
            tagsLabel.text = selectedModelObject["tags"]
            title = selectedModelObject["title"]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPreviewViewController" {
            let photoPreviewVC = segue.destination as! PhotoPreviewViewController
            photoPreviewVC.presentedImage = self.selectedImage
        }
    }
    
    @objc func handleTapGesture() {
        performSegue(withIdentifier: "segueToPreviewViewController", sender: self)
    }
    
    func provideGestureRecognizing() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        singleTapGesture.numberOfTapsRequired = 1
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(singleTapGesture)
    }
}

