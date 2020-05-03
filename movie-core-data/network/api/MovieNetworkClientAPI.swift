//
//  MovieNetworkClientAPI.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

protocol MovieNetworkClientAPI {
    
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


extension MovieNetworkClientAPI {
    func responseHandler<T : Decodable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> T? {
        let TAG = String(describing: T.self)
        if error != nil {
            print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
            return nil
        }
        
        let response = urlResponse as! HTTPURLResponse
        
        if response.statusCode >= 200 && response.statusCode < 300 {
            guard let data = data else {
                print("\(TAG): empty data")
                return nil
            }
            
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                return result
            } else {
                print("\(TAG): failed to parse data")
                return nil
            }
        } else {
            print("\(TAG): Network Error - Code: \(response.statusCode)")
            return nil
        }
    }
}
