//
//  GalleryViewModel.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 21.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreData
import Photos

class GalleryViewModel: NSObject {
    
    //TODO: NSFetchResultsControllerDelegate, sortowanie elementów, usuwanie poszczególnych elementów, szukanie elementów
    
    internal var delegate: GalleryViewModelDelegate? = nil
    var ascendingSortDescriptor: Bool = true
    var galleryName: String!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Thumbnail> = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Thumbnail> = Thumbnail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gallery.name == %@", galleryName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.propertiesToFetch = ["thumbnailImage"]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    init(galleryName: String) {
        super.init()
        self.galleryName = galleryName
    }
    
    
    // - MARK: CoreData methods
    
    func fetchData() {
        do {
            print("FETCHING")
            print(fetchedResultsController.fetchRequest.predicate.debugDescription)
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to perform fetch request: \(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    func searchForObjects(withLocation location: String) {
        self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "gallery.name == %@ AND fullsizePhoto.location CONTAINS[cd] %@", galleryName, location) //[c]ase and [d]iacritic insensitive
        fetchData()
    }
    
    func sortData() {
        let ascending = !ascendingSortDescriptor
        print("ASCENDING: \(ascending)")
        self.fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: ascending)]
        fetchData()
        ascendingSortDescriptor = ascending
    }
    
    func clearPredicatesAndFetch() {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "gallery.name == %@", galleryName)
        fetchData()
    }
    
    
    func save(pickedPhotos: [PHAsset], completion: () -> Void) {
        print("SAVING")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let galleryFetchRequest: NSFetchRequest<Gallery> = Gallery.fetchRequest()
        if let galleryName = galleryName {
            print("GALLERY FETCH PREDICATE ADDED")
            print(galleryName)
            galleryFetchRequest.predicate = NSPredicate(format: "name == %@", galleryName)
        }
        guard let fetchedGallery = try? context.fetch(galleryFetchRequest).first else { return }
        
        for photo in pickedPhotos {
            let imageToSave = photo.getImage()
            var locationToSave = CLLocation()
            if let assetLocation = photo.location {
                locationToSave = assetLocation
            }
            var dateToSave = Date()
            if let assetDate = photo.creationDate {
                dateToSave = assetDate
            }
            
            let photoToSave = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as? Photo
            let thumbnailToSave = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: context) as? Thumbnail
            
            photoToSave!.fullsizePhoto = UIImageJPEGRepresentation(imageToSave, 1.0)
            photoToSave!.location = String(describing: locationToSave)
            photoToSave!.dateStamp = dateToSave
            
            thumbnailToSave!.thumbnailImage = getThumbnailData(from: imageToSave)
            thumbnailToSave!.id = NSDate().timeIntervalSince1970
            thumbnailToSave!.fullsizePhoto = photoToSave
            thumbnailToSave!.gallery = fetchedGallery
            print(thumbnailToSave!.gallery?.name)
            print(thumbnailToSave?.gallery)
        }
        
        appDelegate.saveContext()
        print("SAVED")
        context.refreshAllObjects()
        completion()
    }
    
    func deleteObjects(at indexPaths: [IndexPath]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        for indexPath in indexPaths {
            let objectToDelete = self.fetchedResultsController.object(at: indexPath)
            if let relatedPhoto = objectToDelete.fullsizePhoto {
                context.delete(relatedPhoto)
            }
            context.delete(objectToDelete)
        }
        
        appDelegate.saveContext()
    }
    
    func deleteAllRecords() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Thumbnail.fetchRequest()
        let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.fetchedResultsController.managedObjectContext.execute(deleteRequest)
        } catch {
            print("Error occured while deleting")
        }
    }
    
// ------------------------------------------------------------------------------------------------
    
    func getNumberOfFetchedObjects() -> Int {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }
    
    func getSections() -> [NSFetchedResultsSectionInfo]? {
        let sections = self.fetchedResultsController.sections
        return sections
    }
    
    fileprivate func getThumbnailData(from photo: UIImage) -> Data {
        let newSize: CGSize = CGSize(width: 300.0, height: 300.0)
        let thumbnail: UIImage = photo.scale(to: newSize)
        let thumbnailData: Data = UIImageJPEGRepresentation(thumbnail, 0.7)!
        
        return thumbnailData
    }
    
    func getDataOfFetchedObject(at indexPath: IndexPath) -> (Double, UIImage) {
        let fetchedObject = self.fetchedResultsController.object(at: indexPath)
        let fetchedId = fetchedObject.id
        var fetchedImage = UIImage()
        
        if let fetchedThumbnailData = fetchedObject.thumbnailImage {
            if let imageFromData = UIImage(data: fetchedThumbnailData) {
                fetchedImage = imageFromData
            }
        }
        return (fetchedId, fetchedImage)  
    }
    
}
