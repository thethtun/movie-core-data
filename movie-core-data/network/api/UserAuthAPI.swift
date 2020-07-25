//
//  UserAuthAPI.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

protocol UserAuthAPI : ClientAPI {
    func fetchRequestToken(completion: @escaping (RequestTokenResponse?) -> Void)
    
    func createSessionWithLogin(body : [String : String], completion: @escaping (RequestTokenResponse?) -> Void)
    
    func createSession(body : [String : String], completion : @escaping (CreateSessionResponse?) -> Void)
    
    func logOutSession(sessionId : String, completion : @escaping (GeneralResponse?) -> Void)
}
