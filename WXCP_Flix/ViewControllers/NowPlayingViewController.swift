//
//  NowPlayingViewController.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 8/23/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var centerRefreshIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    var allMovies: [Movie] = []
    var movies: [Movie] = []
    var refreshControl: UIRefreshControl!
    var favorites: [Int] = []
    var imagePosition: String = "left"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        imagePosition = defaults.string(forKey: "imagePositioning") ?? "left"
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        self.centerRefreshIndicator.startAnimating()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        imagePosition = defaults.string(forKey: "imagePositioning") ?? "left"
        tableView.reloadData()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let error = error {
                print(error)
                let alertController = UIAlertController(title: "Cannot Retrieve Movie Data", message: "Cannot connect to the internet", preferredStyle: .alert)
                // create a cancel action
                let tryAgainButton = UIAlertAction(title: "Refresh Data", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                    self.centerRefreshIndicator.startAnimating()
                    self.fetchMovies()
                }
                alertController.addAction(tryAgainButton)
                self.present(alertController, animated: true)
            } else if let movies = movies {
                self.movies = movies
                self.allMovies = self.movies
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.centerRefreshIndicator.stopAnimating()
        }
    }
    
    @IBAction func filterChanged(_ sender: Any) {
        if filterControl.selectedSegmentIndex == 0 {
            self.movies = self.allMovies
        } else {
            self.movies = self.allMovies.filter {
                let movieId = $0.id
                return self.favorites.contains(movieId)
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MovieCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        cell.selectedBackgroundView = backgroundView
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let movie = movies[indexPath.row]
        let movieId = movie.id
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            self.favorites.append(movieId)
        }
        favorite.backgroundColor = UIColor.orange
        
        let unfavorite = UITableViewRowAction(style: .normal, title: "Unfavorite") { action, index in
            //self.isEditing = false
            let index = self.favorites.index(of: movieId)!
            self.favorites.remove(at: index)
            if self.filterControl.selectedSegmentIndex == 1 {
                self.movies = self.allMovies.filter {
                    let movieId = $0.id
                    return self.favorites.contains(movieId)
                }
            }
            self.tableView.reloadData()
        }
        unfavorite.backgroundColor = UIColor.blue
        
        if (favorites.contains(movieId)) {
            return [unfavorite]
        }
        return [favorite]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifer = "MovieCell"
        if (imagePosition.isEqual("right")) {
            identifer = "MovieCellRight"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchViewController {
            dest.allMovies = self.allMovies
        } else if let dest = segue.destination as? DetailViewController {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let movie = movies[indexPath.row]
                dest.movie = movie
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
