//
//  AlbumCollectionViewLayout.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 28.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class AlbumCollectionViewLayout: UICollectionViewLayout {

    // MARK: Properties and Variables
    
    let dragOffset: CGFloat = 180.0
    var cache = [UICollectionViewLayoutAttributes]()
    
    var featuredItemIndex: Int {
        get {
            return max(0, Int(collectionView!.contentOffset.y / dragOffset))
        }
    }
    
    var nextItemPercentageOffset: CGFloat {
        get {
            return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
        }
    }
    
    var width: CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }

    var height: CGFloat {
        get {
            return collectionView!.bounds.height
        }
    }

    var numberOfItems: Int {
        get {
            return collectionView!.numberOfItems(inSection: 0)
        }
    }
    
    // MARK: UICollectionViewLayout
    
    
    override var collectionViewContentSize: CGSize{
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        let standardHeight = LayoutConstants.AlbumCell.standardHeight
        let featuredHeight = LayoutConstants.AlbumCell.extendedHeight
        
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item:item, section:0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.zIndex = item
            var height = standardHeight
            
            if indexPath.item == featuredItemIndex {
                let yOffset = standardHeight * nextItemPercentageOffset
                y = collectionView!.contentOffset.y - yOffset
                height = featuredHeight
            } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
                let maxY = y + standardHeight
                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                y = maxY - height
            }
            
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            y = frame.maxY
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = itemIndex * dragOffset
        return CGPoint(x: 0, y: yOffset)
    }
}
