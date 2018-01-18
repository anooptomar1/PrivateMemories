//
//  PhotoDetailsViewController+CollectionViewDataSource.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 17.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//
import UIKit

extension PhotoDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        cell.tagLabel.text = "#\(tags[indexPath.row])"

        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteTagButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteTagButtonPressed(_ sender: UIButton) {
        photoViewModel?.tags.remove(at: sender.tag)
        tags.remove(at: sender.tag)
        print(sender.tag)
        tagCollectionView.reloadData()
        photoViewModel?.saveImage(asNewObject: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}
