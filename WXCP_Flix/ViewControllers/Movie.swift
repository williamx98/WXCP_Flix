//
//  Movie.swift
//  WXCP_Flix
//
//  Created by Will Xu  on 10/4/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var posterPath: String
    var id: Int
    var overview: String
    var releaseDate: String
    var backdropPath: String
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        posterPath = dictionary["poster_path"] as! String
        id = dictionary["id"] as! Int
        overview = dictionary["overview"] as! String
        releaseDate = dictionary["release_date"] as! String
        backdropPath = dictionary["backdrop_path"] as! String
    }

    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
