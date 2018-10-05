//
//  MovieCell.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 8/24/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            
            let posterPathString = movie.posterPath
            let lowURLString = "https://image.tmdb.org/t/p/w45" + posterPathString
            let highURLString = "https://image.tmdb.org/t/p/original" + posterPathString
            
            let smallImageRequest = URLRequest(url: URL(string: lowURLString)!)
            let largeImageRequest = URLRequest(url: URL(string: highURLString)!)
            let placeholderImage = UIImage(named: "AppIcon")!
            
            
            posterImageView.af_setImage(withURLRequest: smallImageRequest, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false, completion: {(success) -> Void in
                let smallerImage = success.result.value ?? placeholderImage
                self.posterImageView.af_setImage(withURLRequest: largeImageRequest, placeholderImage: smallerImage, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false)
            })
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
