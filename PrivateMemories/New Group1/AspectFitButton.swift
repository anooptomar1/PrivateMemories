//
//  AspectFitButton.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 08.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

class AspectFitButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAspectFitMode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setAspectFitMode()
    }
    
    func setAspectFitMode() {
        if let _imageView = self.imageView {
            _imageView.contentMode = .scaleAspectFit
        }
    }

}
