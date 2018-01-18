//
//  AlbumCollectionViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 28.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AlbumCollectionViewCell"

class AlbumCollectionViewController: UICollectionViewController {

    fileprivate let albumViewModel = AlbumViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        reloadAlbum()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor.darkGray
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func reloadAlbum() {
        self.albumViewModel.fetchData()
        self.collectionView?.reloadData()
    }

    @IBAction func addGalleryButtonPressed(_ sender: Any) {
        presentAddPopup()
    }
    
    func presentAddPopup() {
        let alert = UIAlertController(title: "Add gallery", message: "Enter a gallery name", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Gallery name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let galleryName = textField?.text {
                if galleryName != "" {
                    self.albumViewModel.saveGallery(named: galleryName)
                    self.reloadAlbum()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = self.albumViewModel.getSections() {
            return sections.count
        } else {
            return 0
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("NUMBER OF FETCHED OBJECTS: \(self.albumViewModel.getNumberOfFetchedObjects())")
        return self.albumViewModel.getNumberOfFetchedObjects()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCollectionViewCell
        let fetchedThumbnail: (name: String, creationDate: String) = self.albumViewModel.getDataOfFetchedObject(at: indexPath)
        
        cell.titleLabel.text = fetchedThumbnail.name
        cell.subtitleLabel.text = fetchedThumbnail.creationDate
        cell.imageView.image = UIImage(named: "photo")!
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let galleryVC = GalleryCollectionViewController()
        let selectedGallery: (name: String, creationDate: String) = albumViewModel.getDataOfFetchedObject(at: indexPath)
        print("PUSHING VC")
        galleryVC.selectedGalleryName = selectedGallery.name
        print(selectedGallery.name)
        navigationController?.pushViewController(galleryVC, animated: true)
        
    }

}
