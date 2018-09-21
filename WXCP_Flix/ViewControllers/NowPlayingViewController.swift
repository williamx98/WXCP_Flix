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
    
    var allMovies: [[String: Any]] = []
    var movies: [[String: Any]] = []
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
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 3)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
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
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                var movies = dataDictionary["results"] as! [[String: Any]]
                self.allMovies = movies
                if (self.filterControl.selectedSegmentIndex == 1) {
                    movies = movies.filter {
                        let movieId = $0["id"] as! Int
                        return self.favorites.contains(movieId)
                    }
                }
                self.movies = movies
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.centerRefreshIndicator.stopAnimating()
        }
        task.resume();
    }
    
    @IBAction func filterChanged(_ sender: Any) {
        if filterControl.selectedSegmentIndex == 0 {
            self.movies = self.allMovies
        } else {
            self.movies = self.allMovies.filter {
                let movieId = $0["id"] as! Int
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
        let movieId = movie["id"] as! Int
        
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
                    let movieId = $0["id"] as! Int
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
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        let posterPathString = movie["poster_path"] as! String
        let lowURLString = "https://image.tmdb.org/t/p/w45" + posterPathString
        let highURLString = "https://image.tmdb.org/t/p/original" + posterPathString
        
        let smallImageRequest = URLRequest(url: URL(string: lowURLString)!)
        let largeImageRequest = URLRequest(url: URL(string: highURLString)!)
        let placeholderImage = UIImage(named: "AppIcon")!
        
    
        
        cell.posterImageView.af_setImage(withURLRequest: smallImageRequest, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false, completion: {(success) -> Void in
            let smallerImage = success.result.value ?? placeholderImage
                cell.posterImageView.af_setImage(withURLRequest: largeImageRequest, placeholderImage: smallerImage, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false)
        })

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
