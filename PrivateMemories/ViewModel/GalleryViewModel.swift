//
//  GalleryViewModel.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 21.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreData

class GalleryViewModel: NSObject, NSFetchedResultsControllerDelegate {
    
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
           fetchedImage = UIImage(data: fetchedThumbnailData)!
        }
        return (fetchedId, fetchedImage)  
    }
    
}
