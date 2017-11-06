//
//  StringExtension.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 06.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

extension String {
    func getSize(using font: UIFont) -> CGSize {
        let attributes = [NSAttributedStringKey.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        
        return size
    }
}
