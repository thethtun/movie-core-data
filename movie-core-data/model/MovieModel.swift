//
//  MovieModel.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

class MovieModel {
    
    static let shared = MovieModel()
    
    private init() {}
    
    func fetchMovieDetails(movieId : Int) {
        let route = URL(string: "\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieVO? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                print(data)
//                completion(data.results)
            }
            }.resume()
    }
    
    func fetchTopRatedMovies(pageId : Int = 1, completion : @escaping (([MovieVO]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_TOP_RATED_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                print(data.results.count)
                completion(data.results)
            }
        }.resume()
        
    }
    
    func fetchMovieGenres() {
        
        let route = URL(string: Routes.ROUTE_MOVIE_GENRES)!
        let task = URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieGenreResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            
            if let data = response {
//                print(data)
            }
        }
        task.resume()
    }
    

    
    
    func responseHandler<T : Decodable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> T? {
        let TAG = String(describing: T.self)
        if error != nil {
            print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
            return nil
        }
        
        let response = urlResponse as! HTTPURLResponse
        
        if response.statusCode == 200 {
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
