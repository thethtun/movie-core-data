//
//  RequestTokenResponse.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

struct RequestTokenResponse : Codable {
    let success : Bool?
    let expires_at : String?
    let request_token : String?
}
