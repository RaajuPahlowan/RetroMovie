//
//  MovieService.swift
//  testMovie
//
//  Created by Fahim Mashroor on 13/11/25.
//

import Foundation
import Alamofire

class MovieService{
    static let shared = MovieService()
    private init(){}
    
    private let apikey = "9a45fbd46aba61099e87e3923212cce3"
    
    func fetchPopularMovies(page: Int = 1,
                            completion: @escaping (MovieResponse?) -> Void) {

        let url = "https://api.themoviedb.org/3/movie/popular"
        let parameters: Parameters = [
            "api_key": apikey,
            "language": "en-US",
            "page": page
        ]

        AF.request(url, parameters: parameters)
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(movieResponse)
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                    completion(nil)
                }
            }
    }
    
    
    func fetchTopRatedTVShows(completion: @escaping ([TVShow]) -> Void) {

            let url = "https://api.themoviedb.org/3/tv/top_rated"
            let parameters: Parameters = [
                "api_key": apikey,
                "language": "en-US",
                "page": 1
            ]
        AF.request(url, parameters: parameters)
                   .responseDecodable(of: TVShowResponse.self) { response in
                       switch response.result {
                       case .success(let tvResponse):
                           completion(tvResponse.results)
                       case .failure(let error):
                           print("Error fetching TV shows: \(error)")
                           completion([])
                       }
                   }
           }
    
    func fetchMovieDetail(id: Int, completion: @escaping (MovieDetail?) -> Void) {

        let url = "https://api.themoviedb.org/3/movie/\(id)"
        let parameters: Parameters = [
            "api_key": apikey,
            "language": "en-US"
        ]

        AF.request(url, parameters: parameters)
            .responseDecodable(of: MovieDetail.self) { response in
                switch response.result {
                case .success(let detail):
                    completion(detail)
                case .failure(let error):
                    print("Error fetching movie detail: \(error)")
                    completion(nil)
                }
            }
    }
    
    func fetchMovieCredits(id: Int, completion: @escaping ([CastMember]) -> Void) {

        let url = "https://api.themoviedb.org/3/movie/\(id)/credits"
        let parameters: Parameters = [
            "api_key": apikey,
            "language": "en-US"
        ]

        AF.request(url, parameters: parameters)
            .responseDecodable(of: CreditsResponse.self) { response in
                switch response.result {
                case .success(let credits):
                    completion(credits.cast)
                case .failure(let error):
                    print("Error fetching credits: \(error)")
                    completion([])
                }
            }
    }
    
    func fetchMovieVideos(id: Int, completion: @escaping (VideoItem?) -> Void) {

        let url = "https://api.themoviedb.org/3/movie/\(id)/videos"
        let parameters: Parameters = [
            "api_key": apikey,
            "language": "en-US"
        ]

        AF.request(url, parameters: parameters)
            .responseDecodable(of: VideosResponse.self) { response in
                switch response.result {
                case .success(let videosResponse):
                    let trailer = videosResponse.results.first {
                        $0.site == "YouTube" && $0.type == "Trailer"
                    }
                    completion(trailer)
                case .failure(let error):
                    print("Error fetching videos: \(error)")
                    completion(nil)
                }
            }
    }
}
