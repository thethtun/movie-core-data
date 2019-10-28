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
    
    
    func logOutSession(sessionId : String, completion : @escaping (GeneralResponse?) -> Void) {
        let route = URL(string: "\(API.BASE_URL)/authentication/session?api_key=\(API.KEY)")!
        
        var request = URLRequest(url: route)
        request.httpMethod = "DELETE"
        
        let headers = ["content-type": "application/json"]
        request.allHTTPHeaderFields = headers
        
        let body = [
            "session_id" : sessionId
        ]
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
