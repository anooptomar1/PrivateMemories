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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var insertTagView: UIView!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quotationMarkLeft: UIImageView!
    @IBOutlet weak var quotationMarkRight: UIImageView!
    
    var tags: [String] = []
    
    //MARK: Properties
    
    var isGettingDataFromPicker: Bool = false
    var photoFromPicker: PickedImage?
    var thumbnailId: Double?
    var photoViewModel: PhotoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provideGestureRecognizing()
        descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.backgroundColor = UIColor.xBackground
        addBorders()
        setData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    // MARK: Notifications for the keyboard
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
            self.keyboardWillHide(notification: notification)
        }
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    // MARK: ViewModel
    
    func setViewModel(fromPicker: Bool) {
        if fromPicker {
            photoViewModel = PhotoViewModel(from: photoFromPicker!)
        } else {
            photoViewModel = PhotoViewModel(from: thumbnailId!)
        }
    }
    
    func setData() {
        setViewModel(fromPicker: isGettingDataFromPicker)
        if let viewModel = photoViewModel {
            photoImageView.image = viewModel.fullsizePhoto
            dateLabel.text = viewModel.dateStamp
            tags.append(contentsOf: viewModel.tags)
            descriptionTextView.text = viewModel.descriptionText
            if let presentCityName = viewModel.cityName {
                locationLabel.text = presentCityName
            } else {
                viewModel.getCityName(completion: { (cityName) in
                    self.locationLabel.text = cityName
                })
            }
        }
    }
    
    // MARK: Layout
    
    func setupTextView() {
        let imagePathLeft = UIBezierPath(rect: quotationMarkLeft.frame)
        let imagePathRight = UIBezierPath(rect: quotationMarkRight.frame)
        descriptionTextView.textContainer.exclusionPaths = [imagePathLeft, imagePathRight]
    }
    
    func addBorders() {
        tagView.layer.borderWidth = 1.0
        tagView.layer.borderColor = UIColor.xPurple.cgColor
        insertTagView.layer.borderWidth = 1.0
        insertTagView.layer.borderColor = UIColor.purple.cgColor
    }
    
    // MARK: IBActions
    
    @IBAction func addTagButtonPressed(_ sender: Any) {
        flipImageViews(showTextField: true)
    }
    
    @IBAction func confirmAddTagButtonPressed(_ sender: Any) {
        if let newTag = tagTextField.text {
            tags.append(newTag)
            photoViewModel?.tags.append(newTag)
            tagCollectionView.reloadData()
        }
        flipImageViews(showTextField: false)
        photoViewModel?.saveImage(asNewObject: false)
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
        photoViewModel?.deleteImage()
        navigationController?.popViewController(animated: true)
    }

@IBAction func saveImagePressed(_ sender: Any) {
        photoViewModel?.saveImage(asNewObject: isGettingDataFromPicker)
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

