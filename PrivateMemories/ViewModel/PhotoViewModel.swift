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
    
    let notificationName = "reloadGallery"
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // - MARK: Properties
    var thumbnail: Thumbnail?
    var dateStamp: String = ""
    var cityName: String?
    var locationLat: Double?
    var locationLon: Double?
    var tags: [String] = []
    var descriptionText: String = ""
    var fullsizePhoto: UIImage = UIImage()
    var thumbnailId: Double = NSDate().timeIntervalSince1970
    var galleryName: String?
    let descriptionPlaceholder = "Add text describing the photo, e.g. \"Amazing holidays in New York\""
    
    // - MARK: Initializers
    
    init(from thumbnailId: Double) {
        super.init()
        self.thumbnail = fetchThumbnail(id: thumbnailId)
        if let photo = self.thumbnail?.fullsizePhoto {
            locationLat = photo.locationLat
            locationLon = photo.locationLon
            if let _date = photo.dateStamp { self.dateStamp = getString(from: _date) }
            if let _tags = photo.tags { self.tags = _tags.components(separatedBy: ",")
                for tag in tags {
                    print("TAG: \(tag)")
                }
            }
            if let _photoData = photo.fullsizePhoto { self.fullsizePhoto = getImage(from: _photoData) }
            if let descriptionText = photo.descriptionText { self.descriptionText = (descriptionText == "") ? descriptionPlaceholder : descriptionText }
            if let cityName = photo.cityName { self.cityName = cityName }
            }
        }
    
    init(from pickedImage: PickedImage) {
        super.init()
        galleryName = pickedImage.galleryName
        dateStamp = getString(from: pickedImage.date)
        locationLat = pickedImage.location.coordinate.latitude
        locationLon = pickedImage.location.coordinate.longitude
        fullsizePhoto = pickedImage.image
        descriptionText = descriptionPlaceholder
        if let recognitionTag = pickedImage.tagRecognition {
            tags.append(recognitionTag)
            for tag in tags {
                print("TAG: \(tag)")
            }
        }
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
    
    func getCityName(completion: @escaping (String?) -> ()) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: locationLat!, longitude: locationLon!)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                if let placemarksArray = placemarks {
                    let firstPlacemark = placemarksArray[0]
                        if let locality = firstPlacemark.locality, let country = firstPlacemark.country {
                            let locationString = "\(String(describing: locality)), \(String(describing: country))"
                            self.cityName = locationString
                            completion(locationString)
                            self.saveImage(asNewObject: false)
                        }
                }
            }
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
        let context = appDelegate?.persistentContainer.viewContext
        
        var fetchedThumbnail: Thumbnail?
        let fetchRequest: NSFetchRequest<Thumbnail> = Thumbnail.fetchRequest()
        let predicate = NSPredicate(format: "id == %lf", id)
        fetchRequest.predicate = predicate
        
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
    
    func getGallery(named: String) -> Gallery? {
        let context = appDelegate?.persistentContainer.viewContext
        let galleryFetchRequest: NSFetchRequest<Gallery> = Gallery.fetchRequest()
        galleryFetchRequest.predicate = NSPredicate(format: "name == %@", named)
        return try! context?.fetch(galleryFetchRequest).first
    }
        
        func concatenate(array: [String]) -> String {
            var concatenatedString = ""
            for single in array {
                concatenatedString.append("\(single),")
            }
            return concatenatedString
        }
    
    func saveImage(asNewObject: Bool) {
        let context = appDelegate!.persistentContainer.viewContext
        
        let photoToSave: Photo?
        let thumbnailToSave: Thumbnail?
        
        if asNewObject {
            photoToSave = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo
            thumbnailToSave = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: context) as? Thumbnail
            thumbnailToSave?.gallery = getGallery(named: galleryName!)
        } else {
            thumbnailToSave = self.thumbnail
            photoToSave = self.thumbnail?.fullsizePhoto
        }
        photoToSave!.fullsizePhoto = UIImageJPEGRepresentation(self.fullsizePhoto, 1.0)
        photoToSave!.locationLon = locationLon!
        photoToSave!.locationLat = locationLat!
        photoToSave!.cityName = cityName
        photoToSave!.dateStamp = getDate(from: self.dateStamp)
        photoToSave!.tags = concatenate(array: tags)
        photoToSave!.descriptionText = (descriptionText == descriptionPlaceholder) ? "" : descriptionText
        
        thumbnailToSave!.thumbnailImage = getThumbnailData(from: self.fullsizePhoto)
        thumbnailToSave!.id = self.thumbnailId
        thumbnailToSave!.fullsizePhoto = photoToSave
        
        appDelegate?.saveContext()
        context.refreshAllObjects()
    }
    
    func deleteImage() {
        let context = appDelegate!.persistentContainer.viewContext
        context.delete(thumbnail!)
        appDelegate?.saveContext()
        context.refreshAllObjects()
    }
    
}
