//
//  GalleryCollectionViewController+GalleryViewModelDelegate.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 24.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import Foundation

extension GalleryCollectionViewController: GalleryViewModelDelegate {
    
    func didChangeContent() {
        print("STARTED DELEGATE DIDCHANGECONTENT")
         //Checks if we should reload the collection view to fix a bug @ http://openradar.appspot.com/12954582
            if (self.shouldReloadCollectionView) {
                DispatchQueue.main.async {
                   print("RELOADING DATA")
                    self.collectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView!.performBatchUpdates({ () -> Void in
                        
                     print("PERFORMING BATCH UPDATES")
                        for operation: BlockOperation in self.blockOperations {
                            ("OPERATION STARTED: \(operation.debugDescription)")
                            operation.start()
                        }
                    }, completion: { (finished) -> Void in
                        
                        print("BATCH UPDATES COMPLETED - REMOVING")
                        self.blockOperations.removeAll(keepingCapacity: false)
                    })
                }
            }
    }

    func insert(object: Any, to newIndexPath: IndexPath) {
         print("STARTED DELEGATE INSERT")
        if (collectionView?.numberOfSections)! > 0 {
                if collectionView?.numberOfItems( inSection: newIndexPath.section ) == 0 {
                    self.shouldReloadCollectionView = true
                } else {
                    print("ADDING INSERTING BLOCK")
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            print("INSERTING ALMOST STARTED")
                            if let this = self {
                                print("THIS IS SELF")
                              // DispatchQueue.main.async {
                                    print("INSERTING STARTED")
                                    this.collectionView!.insertItems(at: [newIndexPath])
                                //}
                            } else {
                                print("THIS IS NOT SELF")
                            }
                        })
                    )
                }
            
        } else {
            self.shouldReloadCollectionView = true
        }
    }
    
    func update(object: Any, from indexPath: IndexPath) {
        print("STARTED DELEGATE UPDATE")
        blockOperations.append(
            BlockOperation(block: { [weak self] in
                if let this = self {
                    DispatchQueue.main.async {
                        this.collectionView!.reloadItems(at: [indexPath])
                    }
                }
            })
         )
    }
    
    func move(object: Any, from indexPath: IndexPath, to newIndexPath: IndexPath) {
        print("STARTED DELEGATE MOVE")
        blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            this.collectionView!.moveItem(at: indexPath, to: newIndexPath)
                        }
                    }
                })
        )
    }
    
    func delete(object: Any, from indexPath: IndexPath) {
        print("STARTED DELEGATE DELETE")
        if collectionView?.numberOfItems( inSection: indexPath.section ) == 1 {
                self.shouldReloadCollectionView = true
            } else {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                           // DispatchQueue.main.async {
                                this.collectionView!.deleteItems(at: [indexPath])
                         //   }
                        }
                    })
                )
        }
    }

}
