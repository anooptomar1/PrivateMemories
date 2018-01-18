//
//  PhotoDetailsViewController+UITextViewDelegate.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 18.01.2018.
//  Copyright © 2018 Krzysztof Babis. All rights reserved.
//

import UIKit

extension PhotoDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print("TEXTVIEW HAS BEEN CHANGED")
        resize(textView)
    }
    
    func resize(_ textView: UITextView) {
        print("RESIZING")
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("TEXTVIEW STARTED EDITING")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        photoViewModel?.descriptionText = textView.text
        print("SAVING WITH TEXT: \(textView.text)")
        photoViewModel?.saveImage(asNewObject: false)
        print("VIEW MODEL TEXT: \(photoViewModel?.descriptionText)")
    }
}
