//
//  PosterCell.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 8/25/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    var movie: Movie! {
        didSet {
            let posterPathString = movie.posterPath
            let lowURLString = "https://image.tmdb.org/t/p/w45" + posterPathString
            let highURLString = "https://image.tmdb.org/t/p/original" + posterPathString
            
            let smallImageRequest = URLRequest(url: URL(string: lowURLString)!)
            let largeImageRequest = URLRequest(url: URL(string: highURLString)!)
            let placeholderImage = UIImage(named: "AppIcon")!
            
            
            
            posterImage.af_setImage(withURLRequest: smallImageRequest, placeholderImage: placeholderImage, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false, completion: {(success) -> Void in
                let smallerImage = success.result.value ?? placeholderImage
                self.posterImage.af_setImage(withURLRequest: largeImageRequest, placeholderImage: smallerImage, imageTransition: .crossDissolve(0.7), runImageTransitionIfCached: false)
            })
        }
    }
}
