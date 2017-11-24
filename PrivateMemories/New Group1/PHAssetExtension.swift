//
//  PHAssetExtension.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 24.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit
import Photos

extension PHAsset {
    
    func getImage() -> UIImage {
        var img = UIImage()
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: self, options: options) { data, _, _, _ in
            if let data = data {
                if let imageFromData = UIImage(data: data) {
                    img = imageFromData
                }
            }
        }
        return img
    }
}
