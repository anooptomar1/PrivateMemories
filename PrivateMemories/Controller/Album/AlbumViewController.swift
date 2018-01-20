//
//  AlbumViewController.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 28.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AlbumCollectionViewCell"

class AlbumViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let albumViewModel = AlbumViewModel()
    fileprivate let gallerySegueIdentifier = "toGallerySegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        setupLayout()
        reloadAlbum()
    }
    
    func setupLayout() {
        view.backgroundColor = UIColor.darkGray
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func reloadAlbum() {
        self.albumViewModel.fetchData()
        self.collectionView?.reloadData()
    }

    @IBAction func addGalleryButtonPressed(_ sender: Any) {
        presentAddPopup()
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        let indexPathOfDeletedGallery = IndexPath(row: sender.tag, section: 0)
        albumViewModel.delete(at: indexPathOfDeletedGallery)
        reloadAlbum()
    }
    
    // MARK: Navigation methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == gallerySegueIdentifier, let galleryVC = segue.destination as? GalleryCollectionViewController {
            let selectedCellIndexPath = collectionView?.indexPath(for: (sender as! UICollectionViewCell))
            let selectedGallery: (name: String, creationDate: String) = albumViewModel.getDataOfFetchedObject(at: selectedCellIndexPath!)
            print("PUSHING VC")
            galleryVC.selectedGalleryName = selectedGallery.name
        }
    }
    
    func presentAddPopup() {
        let alert = UIAlertController(title: "Add gallery", message: "Enter a gallery name", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Gallery name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let galleryName = textField?.text {
                if galleryName != "" {
                    self.albumViewModel.saveGallery(named: galleryName, completion: { (addedSuccessfully) in
                        if !addedSuccessfully {
                            let alert = UIAlertController(title: "Error", message: "This gallery name is already taken", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    self.reloadAlbum()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
    
extension AlbumViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumViewModel.getNumberOfFetchedObjects()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCollectionViewCell
        let fetchedThumbnail: (name: String, creationDate: String) = self.albumViewModel.getDataOfFetchedObject(at: indexPath)
        
        cell.layer.cornerRadius = 10
        cell.titleLabel.text = fetchedThumbnail.name
        cell.subtitleLabel.text = fetchedThumbnail.creationDate
        cell.imageView.image = UIImage(named: "cellBg\((indexPath.row)%8)")!
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }
}
