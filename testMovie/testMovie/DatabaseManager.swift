//
//  DatabaseManager.swift
//  testMovie
//
//  Created by Fahim Mashroor on 17/11/25.
//

import SQLite

class DatabaseManager {
        
    static let shared = DatabaseManager()
    var db: Connection?

    let moviesTable = Table("movies")
    let dbId = Expression<Int>("dbId")
    let tmdbId = Expression<Int>("tmdbId")
    let title = Expression<String>("title")
    let posterPath = Expression<String>("posterPath")

    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/movies.sqlite3")
            try db?.run(moviesTable.drop(ifExists: true))   ///temp line
            try createTable()
        } catch {
            print("Database connection error: \(error)")
        }
    }

    func createTable() throws {
        try db?.run(moviesTable.create(ifNotExists: true) { t in
            t.column(dbId, primaryKey: .autoincrement)
            t.column(tmdbId)
            t.column(title)
            t.column(posterPath)
        })
    }

    func saveMovie(tmdbId: Int, title: String, posterPath: String) {
        let insert = moviesTable.insert(self.tmdbId <- tmdbId, self.title <- title, self.posterPath <- posterPath)
        do {
            try db?.run(insert)
            print("\(title) inserted!")
        } catch {
            print("Failed to insert movie: \(error)")
        }
    }

//    func getSavedMovies() -> [Movie] {
//        var savedMovies: [Movie] = []
//        do {
//            for movie in try db!.prepare(moviesTable) {
//                savedMovies.append(Movie(tmdbId: movie[tmdbId], id: movie[id], title: movie[title], posterPath: movie[posterPath]))
//            }
//        } catch {
//            print("Failed to fetch saved movies: \(error)")
//        }
//        return savedMovies
//    }
    
    
    func getSavedMovies() -> [SavedMovie] {
        var savedMovies: [SavedMovie] = []
        do {
            for row in try db!.prepare(moviesTable) {
                let movie = SavedMovie(
                                    dbId: row[dbId],
                                    tmdbId: row[tmdbId],
                                    title: row[title],
                                    posterPath: row[posterPath]
                                )
                                savedMovies.append(movie)
                            }
                        } catch {
                            print("Failed to fetch saved movies: \(error)")
                        }
        return savedMovies
    }

    
    func deleteMovie(dbId: Int) {
        do {
            let movieRow = moviesTable.filter(self.dbId == dbId)
            try db?.run(movieRow.delete())
            print("Deleted movie with dbId \(dbId)")
        } catch {
            print("Failed to delete movie: \(error)")
        }
    }

}

