//
//  GalleryViewModel+NSFetchedResultsControllerDelegate.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 24.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import CoreData

protocol GalleryViewModelDelegate {
    func didChangeContent()
    func insert(object: Any, to newIndexPath: IndexPath)
    func update(object: Any, from indexPath: IndexPath)
    func move(object: Any, from indexPath: IndexPath, to NewIndexPath: IndexPath)
    func delete(object: Any, from indexPath: IndexPath)
}

extension GalleryViewModel: NSFetchedResultsControllerDelegate {
    
    // TODO: Unsafely unwrapped indexPaths
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("STARTED DID CHANGE OBJECT")
        
        if type == NSFetchedResultsChangeType.insert {
            
            print("STARTED FRC INSERT")
            
            delegate?.insert(object: anObject, to: newIndexPath!)
        }
        else if type == NSFetchedResultsChangeType.update {
            print("STARTED FRC UPDATE")
            delegate?.update(object: anObject, from: indexPath!)
        }
        else if type == NSFetchedResultsChangeType.move {
            print("STARTED FRC MOVE")
            delegate?.move(object: anObject, from: indexPath!, to: newIndexPath!)
        }
        else if type == NSFetchedResultsChangeType.delete {
            print("STARTED FRC DELETE")
           delegate?.delete(object: anObject, from: indexPath!)
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("STARTED DID CHANGE CONTENT")
       delegate?.didChangeContent()
    }
}

