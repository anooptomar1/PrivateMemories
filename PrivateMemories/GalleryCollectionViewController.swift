//
//  GalleryCollectionViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 30.10.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GalleryCollectionViewCell"

class GalleryCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitlelessBackButton()
    }
    
    func setTitlelessBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailsViewController" {
            let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
            let selectedCell = sender as! UICollectionViewCell
               photoDetailsViewController.selectedPhotoIndexPath = collectionView?.indexPath(for: selectedCell)
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        
        if let imageName = model.posts[indexPath.row]["image"] {
            cell.photoImageView.image = UIImage(named: imageName)
        }
        
        return cell
    }


}
