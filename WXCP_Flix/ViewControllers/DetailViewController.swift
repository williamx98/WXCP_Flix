//
//  DetailViewController.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 8/25/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie.title
            releaseDateLabel.text = movie.releaseDate
            overviewLabel.text = movie.overview
            let backdropPathString = movie.backdropPath
            let posterPathString = movie.posterPath
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            
            let backdropURL = URL(string: baseURLString + backdropPathString)
            let posterURL = URL(string: baseURLString + posterPathString)
            
            self.backdropImageView.af_setImage(withURL: backdropURL!)
            self.posterImageView.af_setImage(withURL: posterURL!)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TrailerViewController {
            dest.movie = self.movie
        } else if let dest = segue.destination as? SimilarViewController {
            dest.movie = self.movie
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
