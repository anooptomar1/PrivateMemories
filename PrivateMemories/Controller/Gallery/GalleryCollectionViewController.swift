//
//  GalleryCollectionViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class GalleryCollectionViewController: UIViewController {
    
    internal let reuseIdentifier = "GalleryCollectionViewCell"
    internal let modelToDetailsSegueIdentifier = "collectionToDetailsViewController"
    let notificationName = "reloadGallery"
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    internal var padding: CGFloat = 2.0
    
    internal let galleryViewModel = GalleryViewModel()
    internal var blockOperations: [BlockOperation] = []
    internal var shouldReloadCollectionView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryViewModel.delegate = self
        loadPhotos()
        addReloadingObserver()
        setTitlelessBackButton()
    }
    
    deinit {
        print("STARTED DELEGATE DEINIT")
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func addReloadingObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadGallery), name: NSNotification.Name(rawValue: self.notificationName), object: nil)
    }
    
    @objc func reloadGallery() {
        self.loadPhotos()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func loadPhotos() {
        self.galleryViewModel.fetchData()
    }
    
    func setTitlelessBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        setEditingMode(!isEditing)
    }
    
    func setEditingMode(_ isEditingOn: Bool) {
        setEditing(isEditingOn, animated: true)
        //zmienic tytul/obrazek dla przycisku edycji na usun
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.collectionView.allowsMultipleSelection = editing
        let visibleItemsIndexPaths: [IndexPath] = self.collectionView.indexPathsForVisibleItems
        
        for indexPath in visibleItemsIndexPaths {
            self.collectionView.deselectItem(at: indexPath, animated: false)
            let cell: GalleryCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
            cell.isEditing = editing
            
            if editing {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(self.deleteSelectedImages))
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
            
        }
        
    }
    
    @objc func deleteSelectedImages() {
        if let selectedItemsIndexPaths = self.collectionView.indexPathsForSelectedItems {
            //self.collectionView.deleteItems(at: selectedItemsIndexPaths)
            self.galleryViewModel.deleteObjects(at: selectedItemsIndexPaths)
        }
        setEditingMode(false)
    }
    
    
    // MARK: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
        
        if identifier == modelToDetailsSegueIdentifier {
            photoDetailsViewController.isGettingDataFromPicker = false
            let selectedCellIndexPath = sender as! IndexPath
            let selectedCell = self.collectionView.cellForItem(at: selectedCellIndexPath) as! GalleryCollectionViewCell
            photoDetailsViewController.thumbnailId = selectedCell.thumbnailId
        }
    }
    
    // MARK: IBActions
    
    @IBAction func deleteAllButtonPressed(_ sender: Any) {
        self.galleryViewModel.deleteAllRecords()
        reloadGallery()
    }
    
    @IBAction func pickMultipleButtonPressed(_ sender: Any) {
        pickMultiplePhotos()
    }
    
    
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
