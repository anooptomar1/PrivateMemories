//
//  CGSizeExtension.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 18.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit


extension CGSize {
    func resizeFill(toSize: CGSize) -> CGSize {
        let scale: CGFloat = (self.height / self.width) < (toSize.height / toSize.width) ? (self.height / toSize.height) : (self.width / toSize.width)
        let scaledWidth = self.width / scale
        let scaledHeight = self.height / scale
        return CGSize(width: scaledWidth, height: scaledHeight)
    }
}
