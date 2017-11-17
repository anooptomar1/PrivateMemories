//
//  GalleryCollectionViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import Photos
import CoreData

private let reuseIdentifier = "GalleryCollectionViewCell"

class GalleryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var padding: CGFloat = 2.0
    
    var pickedImageToPass: UIImage?
    var pickedMetadataToPass: (location: String, date: String) = ("","")
    var collectionViewLayoutCounter: Int = 0
    
    var images: [Photo] = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
        setTitlelessBackButton()
    }
    
    func setTitlelessBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
        
        if identifier == "collectionToDetailsViewController" {
            photoDetailsViewController.isDataLoadedFromModel = true
            let selectedCell = sender as! UICollectionViewCell
               photoDetailsViewController.presentedPhotoIndexPath = collectionView?.indexPath(for: selectedCell)
        } else if identifier == "imagepickerToDetailsViewController" {
            photoDetailsViewController.isDataLoadedFromModel = false
            photoDetailsViewController.presentedImage = pickedImageToPass
            photoDetailsViewController.photoMetadata = pickedMetadataToPass
        }
    }
    
    @IBAction func pickPhotoButtonPressed(_ sender: Any) {
        configureAndPresentPhotoPicker()
    }
    


    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return model.posts.count
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        
        //if let imageName = model.posts[indexPath.row]["image"] {
        if let imageData = images[indexPath.row].fullsizePhoto {
            cell.photoImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }

}

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - 2*padding
        let widthPerItem = availableWidth/3
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
}

extension GalleryCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        pickedImageToPass = image
        let url = info[UIImagePickerControllerReferenceURL] as! URL
        let assetsCollection = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
        let location = assetsCollection.firstObject?.location
        let date = assetsCollection.firstObject?.creationDate
        if let dateToSet = date, let locationToSet = location {
            setDataAndDismiss(date: dateToSet, location: locationToSet)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func configureAndPresentPhotoPicker() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status != .authorized {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
            })
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        self.present(picker, animated: true, completion: nil)
    }
    
    func setDataAndDismiss(date: Date, location: CLLocation){
        
       
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension GalleryCollectionViewController {
    func loadImages() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.propertiesToFetch = ["fullsizePhoto"]
        do {
            try images = context.fetch(fetchRequest)
        } catch {
            print("Error occured while fetching")
        }
    }
}