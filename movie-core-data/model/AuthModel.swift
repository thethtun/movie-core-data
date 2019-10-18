//
//  AuthModel.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

class AuthModel : BaseModel {
    
    static let shared = AuthModel()
    
    private override init() {}
    
    func fetchRequestToken(completion: @escaping (RequestTokenResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/authentication/token/new?api_key=\(API.KEY)")!
        
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : RequestTokenResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    
    
    func createSessionWithLogin(body : [String : String], completion: @escaping (RequestTokenResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/authentication/token/validate_with_login?api_key=\(API.KEY)")!
        
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        
        let headers = ["content-type": "application/json"]
        request.allHTTPHeaderFields = headers
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let response : RequestTokenResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
        
    }
    
    func createSession(body : [String : String], completion : @escaping (CreateSessionResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/authentication/session/new?api_key=\(API.KEY)")!
        
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        
        let headers = ["content-type": "application/json"]
        request.allHTTPHeaderFields = headers
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let response : CreateSessionResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            } else {
                completion(nil)
            }
            }.resume()
        
    }
    
    
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
    
    
    func fetchRatedMovies() {
        
    }
    
    
}
