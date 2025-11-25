//
//  TableViewController.swift
//  testMovie
//
//  Created by Fahim Mashroor on 13/11/25.
//

import UIKit
import FSPagerView

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSPagerViewDataSource, FSPagerViewDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var pagerView: FSPagerView!
    
    var savedMovies: [SavedMovie] = []
    var movies: [Movie] = []
    var topShows: [TVShow] = []
    var currentPage = 1
    var totalPages = 1
    var isLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        table.delegate = self
        pagerView.dataSource = self
        pagerView.delegate = self
        
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "pagerCell")
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 1.5
        pagerView.interitemSpacing = 0
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.backgroundColor = .clear
        view.backgroundColor = .systemBackground
        pagerView.itemSize = FSPagerView.automaticSize

        fetchMovies(page: 1)
        fetchTopShows()
    }
    
    
    @IBAction func folderButtonTapped(_ sender: Any) {

        RoutingController.goToSavedMoviesViewController(from: self)
    }
    

    private func fetchMovies(page: Int = 1) {
        guard !isLoading else { return }
        guard page <= totalPages else { return }

        isLoading = true
        showTableFooterLoading(page > 1)

        MovieService.shared.fetchPopularMovies(page: page) { [weak self] response in DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                self.showTableFooterLoading(false)
                guard let response = response else { return }

                if page == 1 {
                    self.movies = response.results
                } else {
                    self.movies.append(contentsOf: response.results)
                }

                self.currentPage = response.page
                self.totalPages = response.totalPages

                self.table.reloadData()
            }
        }
    }

    
    private func fetchTopShows() {
            MovieService.shared.fetchTopRatedTVShows { [weak self] shows in
                DispatchQueue.main.async {
                    self?.topShows = shows
                    self?.pagerView.reloadData()
                }
            }
        }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! CustomTableViewCell

        cell.label.text = movie.title

        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullURL = URL(string: baseURL + (movie.posterPath ?? ""))

        cell.iconImageView.load(from: fullURL)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

         var movie = movies[indexPath.row]
            
        RoutingController.goToMovieDetailViewController(from: self, with: movie)
        }
    
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {

        let lastRowIndex = movies.count - 1
        if indexPath.row == lastRowIndex {          // when the last cell is about to appear → load next page
            fetchMovies(page: currentPage + 1)
        }
    }

    
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
            return topShows.count
        }
    func pagerView(_ pagerView: FSPagerView,cellForItemAt index: Int) -> FSPagerViewCell {

            let show = topShows[index]
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "pagerCell", at: index)

            let baseURL = "https://image.tmdb.org/t/p/w500"
            let url = URL(string: baseURL + (show.backdropPath ?? ""))

            cell.imageView?.load(from: url)
            cell.imageView?.clipsToBounds = false
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.layer.cornerRadius = 12
            cell.imageView?.layer.masksToBounds = false
        
            cell.contentView.layer.cornerRadius = 12
            cell.contentView.layer.shadowColor = UIColor.black.cgColor
            cell.contentView.layer.shadowOpacity = 0.15
            cell.contentView.layer.shadowRadius = 8
            cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        
            cell.textLabel?.text = show.name
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            cell.textLabel?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            cell.textLabel?.textColor = .white
        
            let h: CGFloat = 40
            cell.textLabel?.frame = CGRect(
                x: 0,
                y: cell.contentView.bounds.midY - h / 2,
                width: cell.contentView.bounds.width,
                height: h
            )

            return cell
        }
    
    private func showTableFooterLoading(_ show: Bool) {
        if show {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: table.bounds.width, height: 64)
            table.tableFooterView = spinner
        } else {
            table.tableFooterView = nil
        }
    }


}

    
    

