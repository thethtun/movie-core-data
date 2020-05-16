//
//  MockMovieNetworkClient.swift
//  MovieAppUnitTest
//
//  Created by Thet Htun on 5/16/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
@testable import movie_core_data

class MockMovieNetworkClient: MovieNetworkClientAPI {
    
    func fetchMovieList(completion: @escaping ([MovieInfoResponse]) -> Void) {
        completion([MovieInfoResponse(popularity: 0, vote_count: 0, video: false,
                                      poster_path: nil, id: nil, adult: nil,
                                      backdrop_path: nil, original_language: nil,
                                      original_title: nil, genre_ids: nil, title: nil,
                                      vote_average: nil, overview: nil, release_date: nil,
                                      budget: nil, homepage: nil, imdb_id: nil, revenue: nil,
                                      runtime: nil, tagline: nil)])
    }
    
    func fetchMovieVideo(movieId: Int, completion: @escaping ((MovieVideoResponse?) -> Void)) {
        completion(nil)
    }
    
    func fetchSimilarMovies(movieId: Int, completion: @escaping (([MovieInfoResponse]) -> Void)) {
        completion([])
    }
    
    func searchMoviesByName(movieName: String, completion: @escaping (([MovieInfoResponse]) -> Void)) {
        completion([])
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (MovieInfoResponse) -> Void) {
        //Parse & json response object
    }
    
    func fetchTopRatedMovies(pageId: Int, completion: @escaping (([MovieInfoResponse]) -> Void)) {
        completion([])
    }
    
    func fetchPopularMovies(pageId: Int, completion: @escaping (([MovieInfoResponse]) -> Void)) {
        completion([])
    }
    
    func fetchUpcomingMovies(pageId: Int, completion: @escaping (([MovieInfoResponse]) -> Void)) {
        completion([])
    }
    
    func fetchNowPlaying(pageId: Int, completion: @escaping (([MovieInfoResponse]) -> Void)) {
        completion([])
    }
    
    func fetchMovieGenres(completion: @escaping ([MovieGenreResponse]) -> Void) {
        completion([
            MovieGenreResponse(id: 1, name: "Horror")
        ])
    }
    
    
}
