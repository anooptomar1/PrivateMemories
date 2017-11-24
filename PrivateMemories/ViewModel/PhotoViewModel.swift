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
    
    //TODO : Dodać DataManager
    let notificationName = "reloadGallery"
    
    // - MARK: Properties
    var thumbnail: Thumbnail?
    var isFavorite: Bool = false
    var dateStamp: String = ""
    var location: String = ""
    var tags: String = ""
    var fullsizePhoto: UIImage = UIImage()
    var thumbnailId: Double = NSDate().timeIntervalSince1970
    
    // - MARK: Initializers
    
    init(from thumbnailId: Double) {
        super.init()
        self.thumbnail = fetchThumbnail(id: thumbnailId)
        if let photo = self.thumbnail?.fullsizePhoto {
            self.isFavorite = photo.isFavorite
            if let _date = photo.dateStamp { self.dateStamp = getString(from: _date) }
            if let _location = photo.location { self.location = _location }
            if let _tags = photo.tags { self.tags = _tags }
            if let _photoData = photo.fullsizePhoto { self.fullsizePhoto = getImage(from: _photoData) }
        }
    }
    
    init(from pickedImage: PickedImage) {
        super.init()
        dateStamp = getString(from: pickedImage.date)
        location = getString(from: pickedImage.location)
        fullsizePhoto = pickedImage.image
    }
    
    // - MARK: Data parsing methods
    
    fileprivate func getDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.date(from: string)!
    }
    
    fileprivate func getString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    fileprivate func getString(from location: CLLocation) -> String {
        let geocoder = CLGeocoder()
        var locationString = "\(location.coordinate.longitude), \(location.coordinate.latitude)"
        
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                if let placemarksArray = placemarks {
                    let firstPlacemark = placemarksArray[0]
                        if let locality = firstPlacemark.locality, let country = firstPlacemark.country {
                            locationString = "\(String(describing: locality)), \(String(describing: country))"
                            
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
    
    fileprivate func getThumbnailData(from photo: UIImage) -> Data {
        let newSize: CGSize = CGSize(width: 300.0, height: 300.0)
        let thumbnail: UIImage = photo.scale(to: newSize)
        let thumbnailData: Data = UIImageJPEGRepresentation(thumbnail, 0.7)!
        
        return thumbnailData
    }
    
    func notifyAboutReloadingGallery() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
    
    // - MARK: CoreData methods
    
    func fetchThumbnail(id: Double) -> Thumbnail {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        var fetchedThumbnail: Thumbnail?
        let fetchRequest: NSFetchRequest<Thumbnail> = Thumbnail.fetchRequest()
        let predicate = NSPredicate(format: "id == %lf", id)
        fetchRequest.predicate = predicate
        print("FETCHED ITEM ID: \(id)")
        
        do {
            let fetched = try context?.fetch(fetchRequest)
            fetchedThumbnail = fetched?.first
            for fetch in fetched! {
                print(fetch.id)
            }
            
        } catch {
            let fetchError = error as NSError
            print("Unable to perform fetch request: \(fetchError), \(fetchError.localizedDescription)")
        }
        
        return fetchedThumbnail!
    }
    
    func saveImage(asNewObject: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let photoToSave: Photo?
        let thumbnailToSave: Thumbnail?
        
        if asNewObject {
            photoToSave = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo
            thumbnailToSave = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: context) as? Thumbnail
        } else {
            thumbnailToSave = self.thumbnail
            photoToSave = self.thumbnail?.fullsizePhoto
        }
        
        photoToSave!.fullsizePhoto = UIImageJPEGRepresentation(self.fullsizePhoto, 1.0)
        photoToSave!.location = self.location
        photoToSave!.dateStamp = getDate(from: self.dateStamp)
        
        thumbnailToSave!.thumbnailImage = getThumbnailData(from: self.fullsizePhoto)
        thumbnailToSave!.id = self.thumbnailId
        thumbnailToSave!.fullsizePhoto = photoToSave
        
        appDelegate.saveContext()
        context.refreshAllObjects()
        
        notifyAboutReloadingGallery()
    }
    
}
