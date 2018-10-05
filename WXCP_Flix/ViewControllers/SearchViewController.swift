//
//  SearchViewController.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 8/25/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import AlamofireImage

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var allMovies: [Movie] = []
    var searchMatches: [Movie] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        self.searchBar.delegate = self
        self.searchMatches = self.allMovies
        self.collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchMatches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = self.searchMatches[indexPath.item]
        cell.movie = movie
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchMatches = searchText.isEmpty ? self.allMovies : self.allMovies.filter { (item: Movie) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (item.title).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        self.collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailViewController {
            let cell = sender as! UICollectionViewCell
            if let indexPath = collectionView.indexPath(for: cell) {
                let movie = self.searchMatches[indexPath.item]
                dest.movie = movie
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
