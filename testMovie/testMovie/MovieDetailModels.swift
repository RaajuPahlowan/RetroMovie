//
//  MovieDetailModels.swift
//  testMovie
//
//  Created by Fahim Mashroor on 15/11/25.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let overview: String
    let genres: [Genre]
    let voteAverage: Double
    let runtime: Int?
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, runtime
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct CreditsResponse: Decodable {
    let cast: [CastMember]
}

struct CastMember: Decodable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}

struct VideosResponse: Decodable {
    let results: [VideoItem]
}

struct VideoItem: Decodable {
    let key: String
    let name: String
    let site: String   // "YouTube"
    let type: String   // "Trailer"
}
