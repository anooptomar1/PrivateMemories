//
//  AlbumCollectionViewCell.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 28.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let standardHeight = LayoutConstants.AlbumCell.standardHeight
        let featuredHeight = LayoutConstants.AlbumCell.extendedHeight
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        coverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        titleLabel.alpha = delta
        subtitleLabel.alpha = delta
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
    }
    
    
}
