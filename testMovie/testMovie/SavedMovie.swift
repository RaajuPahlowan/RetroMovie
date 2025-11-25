//
//  SavedMovie.swift
//  testMovie
//
//  Created by Fahim Mashroor on 19/11/25.
//

import Foundation

struct SavedMovie {
    let dbId: Int      // local SQLite row id
    let tmdbId: Int    // TMDB movie id
    let title: String
    let posterPath: String
}
