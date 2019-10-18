//
//  CreateSessionResponse.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

struct CreateSessionResponse : Codable {
    let success : Bool?
    let session_id : String?
}
