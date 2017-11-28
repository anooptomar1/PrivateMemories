//
//  AlbumViewModel.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 28.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreData

class AlbumViewModel: NSObject {

    private lazy var fetchedResultsController: NSFetchedResultsController<Gallery> = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Gallery> = Gallery.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        //fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func fetchData() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to perform fetch request: \(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    func saveGallery(named: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let galleryToSave: Gallery = NSEntityDescription.insertNewObject(forEntityName: "Gallery", into: context) as! Gallery
        
        galleryToSave.name = named
        galleryToSave.creationDate = Date()
        
        appDelegate.saveContext()
        context.refreshAllObjects()
    }
    
    func deleteObjects(at indexPaths: [IndexPath]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        for indexPath in indexPaths {
            let objectToDelete = self.fetchedResultsController.object(at: indexPath)
            context.delete(objectToDelete)
        }
        
        appDelegate.saveContext()
    }
    
    fileprivate func getString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getNumberOfFetchedObjects() -> Int {
        guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }
    
    func getSections() -> [NSFetchedResultsSectionInfo]? {
        let sections = self.fetchedResultsController.sections
        return sections
    }
    
    func getDataOfFetchedObject(at indexPath: IndexPath) -> (String, String) {
        let fetchedGalleryObject = self.fetchedResultsController.object(at: indexPath)
        let name = fetchedGalleryObject.name
        let creationDate = fetchedGalleryObject.creationDate
        let dateString = getString(from: creationDate!)

        return (name!, dateString)
    }

}
