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
    
    var allMovies: [[String: Any]] = []
    var searchMatches: [[String: Any]] = []
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
//        let title = movie["title"] as! String
//        let overview = movie["overview"] as! String
        let posterPathString = movie["poster_path"] as! String
        let lowURLString = "https://image.tmdb.org/t/p/w45" + posterPathString
        let highURLString = "https://image.tmdb.org/t/p/original" + posterPathString
        
        let smallImageRequest = URLRequest(url: URL(string: lowURLString)!)
        let largeImageRequest = URLRequest(url: URL(string: highURLString)!)
        let placeholderImage = UIImage(named: "AppIcon")!
        
        
        
        cell.posterImage.af_setImage(withURLRequest: smallImageRequest, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false, completion: {(success) -> Void in
            let smallerImage = success.result.value!
            cell.posterImage.af_setImage(withURLRequest: largeImageRequest, placeholderImage: smallerImage, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false)
        })
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchMatches = searchText.isEmpty ? self.allMovies : self.allMovies.filter { (item: [String:Any]) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (item["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
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
