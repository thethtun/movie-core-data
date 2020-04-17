//
//  MovieModel.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

class MovieModel : BaseModel {
    
    static let shared = MovieModel()
    
    private override init() {}
    
    func fetchMovieVideo(movieId : Int, completion : @escaping ((MovieVideoResponse?) -> Void)) {
        let route = URL(string: "\(API.BASE_URL)/movie/\(movieId)/videos?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieVideoResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    func fetchSimilarMovies(movieId : Int, completion : @escaping (([MovieInfoResponse]) -> Void)) {
        let route = URL(string: "\(API.BASE_URL)/movie/\(movieId)/similar?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
    }
    
    func searchMoviesByName(movieName : String, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let movie = movieName.replacingOccurrences(of: " ", with: "%20")
        let route = URL(string: "\(Routes.ROUTE_SEACRH_MOVIES)?api_key=\(API.KEY)&query=\(movie)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                print("Search Result: \(data.results.count)" )
                completion(data.results)
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
    }
    
    func fetchMovieDetails(movieId : Int, completion: @escaping (MovieInfoResponse) -> Void, failure : ((String) -> Void)?) {
        let route = URL(string: "\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            if let err = error {
                failure?(err.localizedDescription)
            } else {
                let response : MovieInfoResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
                if let data = response {
                    completion(data)
                } else {
                    failure?("data is nil")
                }
            }
            
        }.resume()
    }
    
    func fetchTopRatedMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_TOP_RATED_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
    }
    
    func fetchPopularMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_POPULAR_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
    }
    
    
    func fetchUpcomingMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_UPCOMING_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
    }
    
    
    func fetchNowPlaying(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_NOW_PLAYING_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
    }
    
    
    func fetchMovieGenres(completion : @escaping ([MovieGenreResponse]) -> Void ) {
        
        let route = URL(string: Routes.ROUTE_MOVIE_GENRES)!
        let task = URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieGenreListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.genres)
            }
        }
        task.resume()
    }
    
    
    
    
    
    
}
