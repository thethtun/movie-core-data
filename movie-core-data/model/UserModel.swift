//
//  UserModel.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/28/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation


class UserModel: BaseModel {
    static let shared = UserModel()
    
    private override init() {}
    
    func fetchAccountDetails(sessionId : String, completion : @escaping (UserAccountResponse?) -> Void) {
        
        let route = URL(string: "\(API.BASE_URL)/account?api_key=\(API.KEY)&session_id=\(sessionId)")!
        
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : UserAccountResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    
    func fetchRatedMovies(sessionId : String,completion : @escaping (MovieListResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/account/1/rated/movies?api_key=\(API.KEY)&language=en-US&session_id=\(sessionId)&sort_by=created_at.asc&page=1")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
        
    }
    
    func fetchFavoriteMovies(sessionId : String,completion : @escaping (MovieListResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/account/1/favorite/movies?api_key=\(API.KEY)&session_id=\(sessionId)&language=en-US&sort_by=created_at.asc&page=1")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    func fetchWatchListMovies(sessionId : String,completion : @escaping (MovieListResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/account/1/watchlist/movies?api_key=\(API.KEY)&session_id=\(sessionId)&language=en-US&sort_by=created_at.asc&page=1")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    func rateMovie(movieId : Int,completion : @escaping (GeneralResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/movie/\(movieId)/rating?api_key=\(API.KEY)")!
        
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        
        let headers = ["content-type": "application/json;charset=utf-8"]
        request.allHTTPHeaderFields = headers
        
        let body = [
            "value" : 8.5
            ] as [String : Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let response : GeneralResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    func deleteRating(movieId : Int,completion : @escaping (GeneralResponse?) -> Void) {
     
        let route = URL(string: "\(API.BASE_URL)/movie/\(movieId)/rating?api_key=\(API.KEY)")!
        
        var request = URLRequest(url: route)
        request.httpMethod = "DELETE"
        
        let headers = ["content-type": "application/json;charset=utf-8"]
        request.allHTTPHeaderFields = headers
        
        let body = [String : Any]()
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let response : GeneralResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    func addToWatchList(sessionId : String, movieId : Int, completion : @escaping (GeneralResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/account/1/watchlist?api_key=\(API.KEY)&session_id=\(sessionId)")!
        
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        
        let headers = ["content-type": "application/json;charset=utf-8"]
        request.allHTTPHeaderFields = headers
        
        let body = [
            "media_type" : "movie",
            "media_id" : movieId,
            "watchlist" : true
            ] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let response : GeneralResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
        
    }
    
    func removeFromWatchList(sessionId : String, movieId : Int, completion : @escaping (GeneralResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/account/1/watchlist?api_key=\(API.KEY)&session_id=\(sessionId)")!
        
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        
        let headers = ["content-type": "application/json;charset=utf-8"]
        request.allHTTPHeaderFields = headers
        
        let body = [
            "media_type" : "movie",
            "media_id" : movieId,
            "watchlist" : false
            ] as [String : Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let response : GeneralResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
        
    }
    
    
}
