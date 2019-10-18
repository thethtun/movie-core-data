//
//  UserAccountResponse.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

struct UserAccountResponse : Codable {
    let id : Int?
    let iso_639_1 : String?
    let iso_3166_1 : String?
    let name : String?
    let include_adult : Bool?
    let username : String?
}
