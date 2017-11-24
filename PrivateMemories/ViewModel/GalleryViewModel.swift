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
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Thumbnail> = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Thumbnail> = Thumbnail.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.propertiesToFetch = ["thumbnailImage"]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override init() {
        super.init()
    }
    
    func fetchData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to perform fetch request: \(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    func save(pickedPhotos: [PHAsset]) {
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
            let singlePickedImage = PickedImage(image: imageToSave, location: locationToSave, date: dateToSave)
            let viewModel = PhotoViewModel(from: singlePickedImage)
            viewModel.saveImage(asNewObject: true)
        }
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
    
    func getNumberOfFetchedObjects() -> Int {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count
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

extension GalleryViewModel: NSFetchedResultsControllerDelegate {
    //TODO: Metody NSFetchedViewControllerDelegate
}
