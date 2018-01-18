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
        if let sections = self.galleryViewModel?.getSections() {
            return sections.count
        } else {
            return 0
        }
    }
    
    //TODO: Tytuły sekcji - czy na pewno warto?

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryViewModel?.getNumberOfFetchedObjects() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        guard let fetchedThumbnail: (id: Double, image: UIImage) = self.galleryViewModel?.getDataOfFetchedObject(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.photoImageView.image = fetchedThumbnail.image
        cell.thumbnailId = fetchedThumbnail.id
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            performSegue(withIdentifier: modelToDetailsSegueIdentifier, sender: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                let cellContent = cell
                let rotationAngleDegrees: Double = -30
                let rotationAngleRadians = rotationAngleDegrees * (Double.pi/180)
                let offsetPositioning = CGPoint(x: collectionView.bounds.size.width, y: -20)
                var transform = CATransform3DIdentity
                transform = CATransform3DRotate(transform, CGFloat(rotationAngleRadians), -50, 0, 1)
                transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, -50)
                
                cellContent.layer.transform = transform
                cellContent.layer.opacity = 0.2
                
                let delay = 0.06 * Double(indexPath.row)
                UIView.animate(withDuration: 0.8, delay:delay , usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: { () -> Void in
                    cellContent.layer.transform = CATransform3DIdentity
                    cellContent.layer.opacity = 1
                })
    }
}

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width - 2*padding
        let widthPerItem = availableWidth/CGFloat(numberOfItemsInRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
