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
        
        let searchBar = searchController.searchBar
        //searchBar.scopeButtonTitles = ["All", "Tags", "Location"]
        searchBar.placeholder = "Search photos by location"
        searchBar.becomeFirstResponder()
        searchBar.backgroundColor = UIColor.white.alpha(0.5)
        searchBar.tintColor = UIColor.magenta
        searchBar.delegate = self
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            self.galleryViewModel.searchForObjects(withLocation: searchController.searchBar.text!)
        } else {
            self.galleryViewModel.clearPredicatesAndFetch()
        }
        self.collectionView.reloadData()
    }
}

extension GalleryCollectionViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.galleryViewModel.clearPredicatesAndFetch()
        self.collectionView.reloadData()
        self.searchController.searchBar.resignFirstResponder()
        self.navigationItem.searchController = nil
    }
}
