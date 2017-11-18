//
//  GalleryCollectionViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import CoreData

class GalleryCollectionViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    internal var padding: CGFloat = 2.0
    
    internal let reuseIdentifier = "GalleryCollectionViewCell"
    internal let pickerToDetailsSegueIdentifier = "imagepickerToDetailsViewController"
    internal let modelToDetailsSegueIdentifier = "collectionToDetailsViewController"
    let notificationName = "reloadGallery"
    
    var pickedImageToPass: PickedImage?
    var images: [Photo] = [Photo]()
    
    // - MARK: NSFetchedResultsController delegate
    // TODO: Przenieść do ViewModel
    
    internal lazy var fetchedResultsController: NSFetchedResultsController<Thumbnail> = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Thumbnail> = Thumbnail.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.propertiesToFetch = ["thumbnailImage"]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func loadPhotos() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to perform fetch request: \(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotos()
        addReloadingObserver()
        setTitlelessBackButton()
    }
    
    func addReloadingObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadGallery), name: NSNotification.Name(rawValue: self.notificationName), object: nil)
    }
    
    @objc func reloadGallery() {
        print("NOTIFICATION RECEIVED")
        self.loadPhotos()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func setTitlelessBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
        
        if identifier == modelToDetailsSegueIdentifier {
            photoDetailsViewController.isGettingDataFromPicker = false
        } else if identifier == pickerToDetailsSegueIdentifier {
            photoDetailsViewController.isGettingDataFromPicker = true
            photoDetailsViewController.photoFromPicker = pickedImageToPass
        }
    }
    
    @IBAction func pickPhotoButtonPressed(_ sender: Any) {
        configureAndPresentPhotoPicker()
    }
    
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
