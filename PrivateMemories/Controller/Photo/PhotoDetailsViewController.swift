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
    
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var insertTagView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var tags: [String] = ["example", "photo", "tag", "sample", "ksjskdsjkdsajdaskd", "test", "gallery"]
    
    //MARK: Properties
    
    var isGettingDataFromPicker: Bool = false
    var photoFromPicker: PickedImage?
    var thumbnailId: Double? // czy może id thumbnaila?
    var photoViewModel: PhotoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provideGestureRecognizing()
        setData()
    }
    
    func setData() {
        setViewModel(fromPicker: isGettingDataFromPicker)
        
        if let viewModel = photoViewModel {
            photoImageView.image = viewModel.fullsizePhoto
            if let presentCityName = viewModel.cityName {
                locationLabel.text = presentCityName
            } else {
                viewModel.getCityName(completion: { (cityName) in
                    self.locationLabel.text = cityName
                })
            }
            dateLabel.text = viewModel.dateStamp
        }
    }
    
    func setViewModel(fromPicker: Bool) {
        if fromPicker {
            photoViewModel = PhotoViewModel(from: photoFromPicker!)
        } else {
            photoViewModel = PhotoViewModel(from: thumbnailId!)
        }
    }
    
    @IBAction func addTagButtonPressed(_ sender: Any) {
        flipImageViews(showTextField: true)
    }
    
    @IBAction func confirmAddTagButtonPressed(_ sender: Any) {
        //addTag
        //reloadCollectionView
        flipImageViews(showTextField: false)
    }
    

    @IBAction func cancelAddButtonPressed(_ sender: Any) {
        flipImageViews(showTextField: false)
    }

    @IBAction func shareButtonPressed(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [photoImageView.image!, descriptionTextView.text], applicationActivities: [])
        activityVC.excludedActivityTypes = [.addToReadingList,.copyToPasteboard, .openInIBooks, .markupAsPDF, .postToVimeo, .postToWeibo]
        present(activityVC, animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if let viewModel = photoViewModel {
            viewModel.deleteImage()
            navigationController?.popViewController(animated: true)
        }
    }

@IBAction func saveImagePressed(_ sender: Any) {
    if let viewModel = photoViewModel {
        viewModel.saveImage(asNewObject: isGettingDataFromPicker)
    }
}

// - MARK: Image preview

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
        guard let imageToPreview = photoViewModel?.fullsizePhoto else { return }
        let image = LightboxImage(image: imageToPreview)
        let controller = LightboxController(images: [image], startIndex: 0)
        controller.dynamicBackground = true
        LightboxConfig.PageIndicator.enabled = false
        present(controller, animated: true, completion: nil)
    }
    
    func flipImageViews(showTextField: Bool) {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromTop, .showHideTransitionViews]
        UIView.transition(with: insertTagView, duration: 0.5, options: transitionOptions, animations: {
            self.insertTagView.isHidden = !showTextField
        })
        UIView.transition(with: tagView, duration: 0.5, options: transitionOptions, animations: {
            self.tagView.isHidden = showTextField
        })
    }

}

