//
//  TagCollectionViewCell.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 06.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func setupLayout() {
        self.backgroundColor = UIColor.black
        self.tagLabel.textColor = UIColor.white
        self.layer.cornerRadius = 10.0
    }
}
