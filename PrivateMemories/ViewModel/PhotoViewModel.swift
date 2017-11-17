//
//  PhotoViewModel.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 17.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class PhotoViewModel: NSObject {
    
    // - MARK: Properties
    
    var isFavorite: Bool = false
    var dateStamp: String = ""
    var location: String = ""
    var tags: String = ""
    var fullsizePhoto: UIImage = UIImage()
    
    // - MARK: Initializers
    
    init(from photo: Photo) {
        isFavorite = photo.isFavorite
        if let _date = photo.dateStamp { dateStamp = getString(from: _date) }
        if let _location = photo.location { location = _location }
        if let _tags = photo.tags { tags = _tags }
        if let _photoData = photo.fullsizePhoto { fullsizePhoto = getImage(from: _photoData) }
    }
    
    init(from pickedImage: PickedImage) {
        dateStamp = getString(from: pickedImage.date)
        location = getString(from: pickedImage.location)
        fullsizePhoto = pickedImage.image
    }
    
    // - MARK: Data parsing methods
    
    fileprivate func getDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.date(from: string)
    }
    
    fileprivate func getString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    fileprivate func getString(from location: CLLocation) -> String {
        let geocoder = CLGeocoder()
        var locationString = ""
        
        DispatchQueue.global().async {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                if let placemarksArray = placemarks {
                    let firstPlacemark = placemarksArray[0]
                    locationString = "\(String(describing: firstPlacemark.locality!)), \(String(describing: (firstPlacemark.country!)))"
                }
            }
        }
            return locationString
    }
    
    fileprivate func getImage(from data: Data) -> UIImage {
        var image = UIImage()
        if let imageFromData = UIImage(data: data) {
            image = imageFromData
        }
        return image
    }
    
    // - MARK: CoreData methods
    
    func saveImage() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        if let photoToSave = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo {
            
            photoToSave.fullsizePhoto = UIImageJPEGRepresentation(self.fullsizePhoto, 1.0)
            photoToSave.location = self.location
            photoToSave.dateStamp = getDate(from: self.dateStamp)
            photoToSave.thumbnail = UIImageJPEGRepresentation(self.fullsizePhoto, 0.7)
            // let date : Double = NSDate().timeIntervalSince1970 - dobre dla ID
        }
        
        appDelegate.saveContext()
        
        context.refreshAllObjects() // clear context
    }
    
}
