//
//  PhotoDetailsViewController+CollectionViewDelegateFlowLayout.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 17.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//
import UIKit

extension PhotoDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagStringSize: CGSize = String("#\(tags[indexPath.row])").getSize(using: UIFont.systemFont(ofSize: 15.0))
        let insetWidth: CGFloat = 10.0
        let cellHeight: CGFloat = tagStringSize.height + insetWidth
        let calculatedWidth : CGFloat = tagStringSize.width + 2*insetWidth
        let cellWidth: CGFloat = (calculatedWidth > 60) ? calculatedWidth : 60
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
