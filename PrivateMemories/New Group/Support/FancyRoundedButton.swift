//
//  FancyRoundedButton.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 20.01.2018.
//  Copyright © 2018 Krzysztof Babis. All rights reserved.
//

import UIKit

class FancyRoundedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        self.backgroundColor = UIColor.xBackground
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.contentEdgeInsets = UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0)
        self.layer.masksToBounds = false
    }
}
