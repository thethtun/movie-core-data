//
//  MovieNetworkClient.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

class MovieNetworkClient : MovieNetworkClientAPI  {
    
    static let shared = MovieNetworkClient()
    
    func fetchMovieList(completion : @escaping ([MovieInfoResponse]) -> Void) {
        var movieInfoResponses = [MovieInfoResponse]()
               
        fetchTopRatedMovies(pageId: 1) { [weak self] data in
            data.forEach({ (movieInfo) in
                var data = movieInfo
                data.movieTag = MovieTag.TOP_RATED
                movieInfoResponses.append(data)
            })
            
            self?.fetchPopularMovies(pageId: 1) { [weak self] data in
                data.forEach({ (movieInfo) in
                    var data = movieInfo
                    data.movieTag = MovieTag.POPULAR
                    movieInfoResponses.append(data)
                })
                
                self?.fetchUpcomingMovies(pageId: 1) { [weak self] data in
                    data.forEach({ (movieInfo) in
                        var data = movieInfo
                        data.movieTag = MovieTag.UPCOMING
                        movieInfoResponses.append(data)
                    })
                    
                    self?.fetchNowPlaying(pageId: 1) {  data in
                        data.forEach({ (movieInfo) in
                            var data = movieInfo
                            data.movieTag = MovieTag.NOW_PLAYING
                            movieInfoResponses.append(data)
                        })
                        
                        completion(movieInfoResponses)
                    }
                }
            }
        }
    }
    
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
    
    func fetchMovieDetails(movieId : Int, completion: @escaping (MovieInfoResponse) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieInfoResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
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
