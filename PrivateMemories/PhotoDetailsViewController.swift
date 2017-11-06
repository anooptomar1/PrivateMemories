//
//  PhotoDetailsViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import Lightbox

class PhotoDetailsViewController: UIViewController {
    
    //MARK: IB Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    var tags: [String] = ["example", "photo", "tag", "sample", "ksjskdsjkdsajdaskd", "test", "gallery"]
    
    //MARK: Properties
    
    var presentedPhotoIndexPath: IndexPath?
    var presentedImage: UIImage?
    var photoMetadata: (location: String, date: String) = ("","")
    var isDataLoadedFromModel: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provideGestureRecognizing()
        setData(fromModel: isDataLoadedFromModel)
    }
    
    func setData(fromModel: Bool) {
        if fromModel {
            if let indexPath = presentedPhotoIndexPath {
                let selectedModelObject = model.posts[indexPath.row]
                presentedImage = UIImage(named: selectedModelObject["image"]!)
                likesLabel.text = "♥ \(selectedModelObject["likes"]!) likes"
                postLabel.text = selectedModelObject["description"]
                tagsLabel.text = selectedModelObject["tags"]
                title = selectedModelObject["title"]
            }
        } else {
            likesLabel.text = photoMetadata.location
            postLabel.text = photoMetadata.date
        }
        photoImageView.image = presentedImage
    }

    
    @objc func handleTapGesture() {
        presentImagePreview()
    }
    
    func provideGestureRecognizing() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        singleTapGesture.numberOfTapsRequired = 1
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(singleTapGesture)
    }
    
    func presentImagePreview() {
        guard let imageToPreview = presentedImage else { return }
        let image = LightboxImage(image: imageToPreview)
        let controller = LightboxController(images: [image], startIndex: 0)
        controller.dynamicBackground = true
        LightboxConfig.PageIndicator.enabled = false
        present(controller, animated: true, completion: nil)
    }
    
}

extension PhotoDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        cell.tagLabel.text = tags[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}

extension PhotoDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagStringSize: CGSize = tags[indexPath.row].getSize(using: UIFont.systemFont(ofSize: 17.0))
        let insetWidth: CGFloat = 10.0
        let cellHeight: CGFloat = tagStringSize.height + 2*insetWidth
        let calculatedWidth : CGFloat = tagStringSize.width + 2*insetWidth
        let cellWidth: CGFloat = (calculatedWidth > 60) ? calculatedWidth : 60

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
