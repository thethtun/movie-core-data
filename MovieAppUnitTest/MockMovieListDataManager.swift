//
//  MockMovieListDataManager.swift
//  MovieAppUnitTest
//
//  Created by Thet Htun on 5/16/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
@testable import movie_core_data

class MockMovieListDataManager: MovieListDataManagerProtocol {
    
    var savedMovieList = [MovieInfoResponse]()
    var savedGenreList = [MovieGenreResponse]()
    
    func retrieveMovies() -> [MovieVO] {
        return []
    }
    
    func retrieveGenres() -> [MovieGenreVO] {
        return []
    }
    
    func saveMovies(data: [MovieInfoResponse]) {
        savedMovieList = data
    }
    
    func saveGenres(data: [MovieGenreResponse]) {
        savedGenreList = data
    }
    
    
}
