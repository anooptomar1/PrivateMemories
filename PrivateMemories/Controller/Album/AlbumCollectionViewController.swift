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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        reloadGalleries()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor.darkGray
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func reloadGalleries() {
        self.albumViewModel.fetchData()
        self.collectionView?.reloadData()
    }

    // MARK: - Navigation
 

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
        // cell.imageView.image = getRandomImage()
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO - pushGalleryViewController
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }

}
