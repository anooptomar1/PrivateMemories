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
    
        public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
            let rect = CGRect(origin: .zero, size: size)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
            color.setFill()
            UIRectFill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard let cgImage = image?.cgImage else { return nil }
            self.init(cgImage: cgImage)
        }

        func transform(withNewColor color: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            
            color.setFill()
            context.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
}
