//
//  CameraViewController+ObjectRecognition.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 19.01.2018.
//  Copyright © 2018 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreLocation
import Vision

extension CameraViewController {
    
    func recognizeObject() {
        guard let capturedImage = capturedImageView.image, let image = CIImage(image: capturedImage) else { return }
        
        recognizedObjectLabel.text = "Analyzing image..."
            
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            return
        }
            
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let bestResult = results.first else {
                    return
            }
                
            DispatchQueue.main.async { [weak self] in
                self?.recognizedObjectLabel.text = "\(bestResult.identifier)"
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    func discardRecognition() {
        //isRecognizing = false
        //recognizedObjectView.isHidden = true
    }
    
    func savePhoto() {
        print("TRYING TO SAVE PHOTO")
        guard let currentLocation = userLocation, let capturedPhoto = capturedImageView.image, let galleryName = galleryName else { return }
        print("SAVING PHOTO")
        let pickedImage = PickedImage(galleryName: galleryName, image: capturedPhoto, location: currentLocation, date: Date(), recognizedObjectDescription: recognizedObjectLabel.text)
        let photoViewModel = PhotoViewModel(from: pickedImage)
        photoViewModel.saveImage(asNewObject: true)
    }
    
    func crop(image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return newImage
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
