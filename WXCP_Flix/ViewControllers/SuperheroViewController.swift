//
//  SuperheroViewController.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 8/25/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import AlamofireImage

class SuperheroViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine:CGFloat = 3
        let interSpace = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = (collectionView.frame.size.width/cellsPerLine) - (interSpace/cellsPerLine)
        layout.itemSize = CGSize(width: width, height: width * (3/2))
        
        fetchMovies()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        let movie = movies[indexPath.item]
        cell.movie = movie
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailViewController {
            let cell = sender as! UICollectionViewCell
            if let indexPath = collectionView.indexPath(for: cell) {
                let movie = movies[indexPath.row]
                dest.movie = movie
            }
        }
    }
    
    func fetchMovies() {
        MovieApiManager().getSimilarMovies(id: 63088, completion: { (movies: [Movie]?, error: Error?) in
            if let error = error {
                print(error)
                let alertController = UIAlertController(title: "Cannot Retrieve Movie Data", message: "Cannot connect to the internet", preferredStyle: .alert)
                // create a cancel action
                let tryAgainButton = UIAlertAction(title: "Refresh Data", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                    //                    self.centerRefreshIndicator.startAnimating()
                    self.fetchMovies()
                }
                alertController.addAction(tryAgainButton)
                self.present(alertController, animated: true)
            } else if let movies = movies {
                self.movies = movies
                self.collectionView.reloadData()
            }
        })
    }
    
}
