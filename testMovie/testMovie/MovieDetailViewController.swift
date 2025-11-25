//
//  MovieDetailViewController.swift
//  testMovie
//
//  Created by Fahim Mashroor on 15/11/25.
//

import UIKit

class MovieDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let member = cast[indexPath.item]

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCollectionViewCell

                cell.nameLabel.text = member.name
                cell.characterlabel.text = member.character

                let baseURL = "https://image.tmdb.org/t/p/w200"
                if let path = member.profilePath {
                    cell.profileImageView.load(from: URL(string: baseURL + path))
                } else {
                    cell.profileImageView.image = UIImage(systemName: "person.fill")
                }

                return cell
            }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 100, height: 160)
            }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    var movieId: Int!
    var basicTitle: String?             //data coming from previous page
    var basicPosterPath: String?
    var isBookmarked: Bool = false         //for bookmarkButton
    
    private var movieDetail: MovieDetail?
    private var cast: [CastMember] = []         //internal Data
    private var trailer: VideoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        
        if let layout = castCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               layout.scrollDirection = .horizontal
               layout.itemSize = CGSize(width: 100, height: 160)
               layout.minimumLineSpacing = 12
               layout.minimumInteritemSpacing = 12
               layout.estimatedItemSize = .zero
           }
        titleLabel.text = basicTitle //for bookmarkButton
        checkIfMovieIsBookmarked()
        
        setupInitialUI()
        loadData()
    }
    
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        guard let basicTitle = basicTitle,
                  let basicPosterPath = basicPosterPath else {
                print("Movie title or poster path is nil")
                return
            }
        if isBookmarked {
                print("Movie already bookmarked!")
                sender.backgroundColor = .clear
            } else {
                DatabaseManager.shared.saveMovie(tmdbId: movieId!, title: basicTitle, posterPath: basicPosterPath)
                sender.backgroundColor = .red
            }            
            isBookmarked.toggle()
    }
    
    
    private func checkIfMovieIsBookmarked() {
        let savedMovies = DatabaseManager.shared.getSavedMovies()
        if savedMovies.contains(where: { $0.title == basicTitle }) {
            isBookmarked = true
            bookmarkButton.backgroundColor = .red
        } else {
            isBookmarked = false
            bookmarkButton.backgroundColor = .clear
        }
    }
    
    
    
    private func setupInitialUI() {
        titleLabel.text = basicTitle
        
        if let posterPath = basicPosterPath {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            posterImageView.load(from: URL(string: baseURL + posterPath))
            posterImageView.contentMode = .scaleAspectFit
        }
        
        overviewLabel.text = "Loading..."
        ratingLabel.text = ""
        genreLabel.text = ""
        trailerButton.isEnabled = false
        trailerButton.alpha = 0.5
    }
    
    private func loadData() {
           guard let movieId = movieId else { return }


           MovieService.shared.fetchMovieDetail(id: movieId) { [weak self] detail in
               guard let self = self, let detail = detail else { return }
                                                                                            //details
               DispatchQueue.main.async {
                   self.movieDetail = detail
                   self.updateDetailUI(with: detail)
               }
           }


           MovieService.shared.fetchMovieCredits(id: movieId) { [weak self] cast in
               DispatchQueue.main.async {                                                      //cast
                   self?.cast = cast
                   self?.castCollectionView.reloadData()
               }
           }

          
           MovieService.shared.fetchMovieVideos(id: movieId) { [weak self] trailer in
               DispatchQueue.main.async {
                   self?.trailer = trailer                                                              //trailer
                   self?.updateTrailerButton()
               }
           }
       }
    
    private func updateDetailUI(with detail: MovieDetail) {
            titleLabel.text = detail.title
            overviewLabel.text = detail.overview

            let genresString = detail.genres.map { $0.name }.joined(separator: ", ")
            genreLabel.text = genresString

            ratingLabel.text = String(format: "⭐️ %.1f / 10", detail.voteAverage)

            if let posterPath = detail.posterPath {
                let baseURL = "https://image.tmdb.org/t/p/w500"
                posterImageView.load(from: URL(string: baseURL + posterPath))
            }
        }
    
    private func updateTrailerButton() {
            if trailer != nil {
                trailerButton.isEnabled = true
                trailerButton.alpha = 1.0
            } else {
                trailerButton.isEnabled = false
                trailerButton.alpha = 0.5
            }
        }
    
    @IBAction func playTrailerTapped(_ sender: UIButton) {
        
        guard let trailer = trailer, trailer.site == "YouTube" else { return }

                let urlString = "https://www.youtube.com/watch?v=\(trailer.key)"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
    }
    

}
