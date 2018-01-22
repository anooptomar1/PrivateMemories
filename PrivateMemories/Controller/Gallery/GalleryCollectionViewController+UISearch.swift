//
//  GalleryCollectionViewController+UISearch.swift
//  PrivateMemories
//
//  Created by Krzysztof Babis on 25.11.2017.
//  Copyright © 2017 Krzysztof Babis. All rights reserved.
//

import UIKit

extension GalleryCollectionViewController: UISearchResultsUpdating {
    
    func loadSearchBar() {
        self.definesPresentationContext = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    
        searchController.searchResultsUpdater = self
        //searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["All", "Location", "Tags"]
        
        let searchBar = searchController.searchBar
        searchBar.becomeFirstResponder()
        searchBar.tintColor = UIColor.white
        searchBar.searchBarStyle = .prominent
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "whiteboard"), for: .normal)
        let textfieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textfieldInsideSearchBar?.textColor = UIColor.white
        let searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
        if let imageView = searchTextField?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: UIColor.white)
        }
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedStringKey.foregroundColor: UIColor.white]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Enter the location or tag", attributes: attributeDict)
        }
        searchBar.delegate = self
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            isCurrentlySearching = true
            self.galleryViewModel?.searchForObjects(withLocation: searchController.searchBar.text!, index: searchController.searchBar.selectedScopeButtonIndex)
        } else {
            self.galleryViewModel?.clearPredicatesAndFetch()
        }
        self.collectionView.reloadData()
    }
}

extension GalleryCollectionViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isCurrentlySearching = false
        self.galleryViewModel?.clearPredicatesAndFetch()
        self.collectionView.reloadData()
        self.searchController.searchBar.resignFirstResponder()
        self.navigationItem.searchController = nil
    }
}
