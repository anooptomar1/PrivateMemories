//
//  GalleryCollectionViewController+ImagePicker.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 17.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import Photos

extension GalleryCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let url = info[UIImagePickerControllerReferenceURL] as! URL
        let assetsCollection = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
        
        let image  = info[UIImagePickerControllerOriginalImage] as! UIImage
        var location = (assetsCollection.firstObject?.location)
        var date = (assetsCollection.firstObject?.creationDate)
        
        //TODO: Poprawić
        if location == nil { location = CLLocation() }
        if date == nil { date = Date() }
        
        pickedImageToPass = PickedImage(image: image, location: location!, date: date!)
        
        performSegue(withIdentifier: pickerToDetailsSegueIdentifier, sender: self)
        dismiss(animated: true, completion: nil)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
