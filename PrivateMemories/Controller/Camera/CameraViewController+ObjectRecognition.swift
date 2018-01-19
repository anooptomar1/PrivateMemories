//
//  CameraViewController+ObjectRecognition.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 19.01.2018.
//  Copyright © 2018 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreLocation

extension CameraViewController {
    
    func recognizeObject() {
        
    }
    
    func discardRecognition() {
        
    }
    
    func savePhoto() {
        print("TRYING TO SAVE PHOTO")
        guard let currentLocation = userLocation, let capturedPhoto = capturedImageView.image, let galleryName = galleryName else { return }
        print("SAVING PHOTO")
        let pickedImage = PickedImage(galleryName: galleryName, image: capturedPhoto, location: currentLocation, date: Date(), recognizedObjectDescription: recognizedObjectLabel.text)
        let photoViewModel = PhotoViewModel(from: pickedImage)
        photoViewModel.saveImage(asNewObject: true)
    }
}

extension CameraViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.distanceFilter = kCLDistanceFilterNone
        locationManager!.requestWhenInUseAuthorization()
    }
}
