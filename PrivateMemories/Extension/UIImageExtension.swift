//
//  UIImageExtension.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 18.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

extension UIImage {
    func scale(to newSize: CGSize) -> UIImage {
     
        let aspectFill = self.size.resizeFill(toSize: newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: aspectFill.width, height: aspectFill.height))
        let scaledImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
