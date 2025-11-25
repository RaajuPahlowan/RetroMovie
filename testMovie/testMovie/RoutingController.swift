//
//  RoutingController.swift
//  testMovie
//
//  Created by Fahim Mashroor on 12/11/25.
//

import UIKit

struct RoutingController {
    
    static func goToResultViewController(
        from source: UIViewController,
        with data: [String: String]
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
            resultVC.recievedData = data
            source.present(resultVC, animated: true, completion: nil)
        }
    }
    
    static func goToTableViewController(
        from source: UIViewController
    ) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tableVC = storyboard.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController{
            source.present(tableVC, animated: true, completion: nil)
        }
        
    }
    
    
    static func goToMovieDetailViewController( from source: UIViewController, with movie: Movie){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailsVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController{
            
            movieDetailsVC.movieId = movie.id
            movieDetailsVC.basicTitle = movie.title
            movieDetailsVC.basicPosterPath = movie.posterPath
            
            source.present(movieDetailsVC, animated: true, completion: nil)
            
        }
    }
    
    
    static func goToSavedMoviesViewController( from source: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let savedMoviesVC = storyboard.instantiateViewController(withIdentifier: "SavedMoviesViewController") as? SavedMoviesViewController{
            source.present(savedMoviesVC, animated: true, completion: nil)
        }
    }
    
    
    static func goToMovieDetailFromSaved( from source: UIViewController, with movie: SavedMovie){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let frommovieDetailVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController{
            frommovieDetailVC.movieId = movie.tmdbId
            frommovieDetailVC.basicTitle = movie.title
            frommovieDetailVC.basicPosterPath = movie.posterPath
            
            source.present(frommovieDetailVC, animated: true, completion: nil)
        }
    }
    
}

