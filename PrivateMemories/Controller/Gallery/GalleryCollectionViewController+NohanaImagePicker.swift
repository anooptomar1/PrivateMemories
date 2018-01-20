//
//  GalleryCollectionViewController+NohanaImagePicker.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 23.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import Photos
import NohanaImagePicker

extension GalleryCollectionViewController: NohanaImagePickerControllerDelegate {
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts: [PHAsset]) {
        dismiss(animated: true) {
            self.galleryViewModel?.save(pickedPhotos: pickedAssts, completion: {
            })
        }
        
    }
    
    func pickMultiplePhotos() {
        checkIfAuthorizedToAccessPhotos { isAuthorized in
            DispatchQueue.main.async(execute: {
                if isAuthorized {
                    self.showLargeThumbnailPicker()
                } else {
                    let alert = UIAlertController(title: "Error", message: "Denied access to photos.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func showLargeThumbnailPicker() {
        let picker = NohanaImagePickerController()
        picker.delegate = self
        picker.maximumNumberOfSelection = 10
        picker.numberOfColumnsInPortrait = 3
        picker.numberOfColumnsInLandscape = 3
        picker.config.color.background = UIColor.white
        picker.config.color.separator = UIColor.black
        picker.config.color.empty = UIColor.magenta
        //picker.canPickAsset
        //picker.toolbarHidden
        present(picker, animated: true, completion: nil)
    }
    
    func checkIfAuthorizedToAccessPhotos(_ handler: @escaping (_ isAuthorized: Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        handler(true)
                    default:
                        handler(false)
                    }
                }
            }
        case .restricted:
            handler(false)
        case .denied:
            handler(false)
        case .authorized:
            handler(true)
        }
    }
    
    
}
