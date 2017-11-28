//
//  GalleryCollectionViewCell.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    let checkedImageName = "checked"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    
    var isEditing: Bool = false {
        didSet {
            self.checkboxImageView.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
//                self.layer.borderColor = UIColor.salmon.cgColor
//                self.layer.borderWidth = isSelected ? 3.0 : 0.0
                self.checkboxImageView!.image = isSelected ? UIImage(named: checkedImageName) : UIImage()
                self.checkboxImageView.contentMode = .center
                self.checkboxImageView.alpha = isSelected ? 0.5 : 0.0
            }
        }
    }
    
    var thumbnailId: Double?
}
