//
//  PickedImage.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 17.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct PickedImage {
    var image: UIImage
    var location: CLLocation
    var date: Date
    
    init(image: UIImage, location: CLLocation, date: Date) {
        self.image = image
        self.location = location
        self.date = date
    }
}
