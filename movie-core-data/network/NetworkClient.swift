//
//  NetworkManager.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/9/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

class NetworkClient : BaseNetworkClient {
    let networkClient : URLSession
    
    init(_ client : URLSession) {
        self.networkClient = client
    }
    
    func searchMoviesByName(movieName : String, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let movie = movieName.replacingOccurrences(of: " ", with: "%20")
        let route = URL(string: "\(Routes.ROUTE_SEACRH_MOVIES)?api_key=\(API.KEY)&query=\(movie)")!
        self.networkClient.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                print("Search Result: \(data.results.count)" )
                completion(data.results)
            } else {
                completion([MovieInfoResponse]())
            }
        }.resume()
    }
    
}
