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
        return self.galleryViewModel.getNumberOfFetchedObjects()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        let fetchedThumbnail: (id: Double, image: UIImage) = self.galleryViewModel.getDataOfFetchedObject(at: indexPath)
        
        cell.photoImageView.image = fetchedThumbnail.image
        cell.thumbnailId = fetchedThumbnail.id
        
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
