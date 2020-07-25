//
//  MovieNetworkClientAPI.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

protocol MovieNetworkClientAPI : ClientAPI {
    
    func fetchMovieList(completion : @escaping ([MovieInfoResponse]) -> Void)
    
    func fetchMovieVideo(movieId : Int, completion : @escaping ((MovieVideoResponse?) -> Void))
    
    func fetchSimilarMovies(movieId : Int, completion : @escaping (([MovieInfoResponse]) -> Void))
    
    func searchMoviesByName(movieName : String, completion : @escaping (([MovieInfoResponse]) -> Void) )
    
    func fetchMovieDetails(movieId : Int, completion: @escaping (MovieInfoResponse) -> Void)
    
    func fetchTopRatedMovies(pageId : Int, completion : @escaping (([MovieInfoResponse]) -> Void) )
    
    func fetchPopularMovies(pageId : Int, completion : @escaping (([MovieInfoResponse]) -> Void) )
    
    func fetchUpcomingMovies(pageId : Int, completion : @escaping (([MovieInfoResponse]) -> Void) )
        
    func fetchNowPlaying(pageId : Int, completion : @escaping (([MovieInfoResponse]) -> Void) )

    func fetchMovieGenres(completion : @escaping ([MovieGenreResponse]) -> Void )
}


