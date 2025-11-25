//
//  Movie.swift
//  testMovie
//
//  Created by Fahim Mashroor on 13/11/25.
//

import Foundation


struct MovieResponse : Decodable{
    let page: Int
    let results: [Movie]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}

struct Movie : Decodable {
    let id: Int
    let title: String
    let posterPath : String?
    
    enum CodingKeys : String, CodingKey{
        case id
        case title
        case posterPath = "poster_path"
    }
}



struct TVShowResponse: Decodable {
    let results: [TVShow]
}
struct TVShow: Decodable {
    let name: String           // TMDB uses "name" for TV shows
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

