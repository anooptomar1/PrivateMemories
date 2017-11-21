//
//  GalleryCollectionViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class GalleryCollectionViewController: UIViewController {
    
    internal let galleryViewModel = GalleryViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    internal var padding: CGFloat = 2.0
    
    internal let reuseIdentifier = "GalleryCollectionViewCell"
    internal let pickerToDetailsSegueIdentifier = "imagepickerToDetailsViewController"
    internal let modelToDetailsSegueIdentifier = "collectionToDetailsViewController"
    let notificationName = "reloadGallery"
    
    var pickedImageToPass: PickedImage?
    var images: [Photo] = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
        addReloadingObserver()
        setTitlelessBackButton()
    }
    
    func addReloadingObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadGallery), name: NSNotification.Name(rawValue: self.notificationName), object: nil)
    }
    
    @objc func reloadGallery() {
        self.loadPhotos()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func loadPhotos() {
        self.galleryViewModel.fetchData()
    }
    
    func setTitlelessBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
        
        if identifier == modelToDetailsSegueIdentifier {
            photoDetailsViewController.isGettingDataFromPicker = false
            let selectedCell = sender as! GalleryCollectionViewCell
            photoDetailsViewController.thumbnailId = selectedCell.thumbnailId
        } else if identifier == pickerToDetailsSegueIdentifier {
            photoDetailsViewController.isGettingDataFromPicker = true
            photoDetailsViewController.photoFromPicker = pickedImageToPass
        }
    }
    
    
    @IBAction func deleteAllButtonPressed(_ sender: Any) {
        self.galleryViewModel.deleteAllRecords()
        reloadGallery()
    }
    
    @IBAction func pickPhotoButtonPressed(_ sender: Any) {
        configureAndPresentPhotoPicker()
    }
    
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
