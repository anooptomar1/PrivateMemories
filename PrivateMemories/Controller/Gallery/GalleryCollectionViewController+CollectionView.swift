//
//  GalleryCollectionViewController+CollectionView.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 17.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

extension GalleryCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let thumbnails = fetchedResultsController.fetchedObjects else { return 0 }
        return thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        let thumbnailObject = fetchedResultsController.object(at: indexPath)
        
        if let thumbnailData = thumbnailObject.thumbnailImage {
            cell.photoImageView.image = UIImage(data: thumbnailData)
        }

        cell.thumbnailId = thumbnailObject.id
        
        return cell
    }
    
}

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - 2*padding
        let widthPerItem = availableWidth/3
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
}
