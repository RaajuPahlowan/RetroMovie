//
//  SavedMoviesViewController.swift
//  testMovie
//
//  Created by Fahim Mashroor on 17/11/25.
//

import UIKit
import SQLite

class SavedMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieLabel: UILabel!
    
    var savedMovies: [SavedMovie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        savedMovies = DatabaseManager.shared.getSavedMovies()
        print(savedMovies)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMovies.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = savedMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedMovieCell", for: indexPath) as! CustomTableViewCell
        cell.savedLabel.text = movie.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = savedMovies[indexPath.row]
        RoutingController.goToMovieDetailFromSaved(from: self, with: movie)
    }
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
           let pointInTable = sender.convert(CGPoint.zero, to: tableView)
           guard let indexPath = tableView.indexPathForRow(at: pointInTable) else { return }
           let movie = savedMovies[indexPath.row]
           DatabaseManager.shared.deleteMovie(dbId: movie.tmdbId)
           savedMovies.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}

