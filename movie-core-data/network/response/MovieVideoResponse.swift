//
//  MovieVideoResponse.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/11/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation

struct MovieVideoResponse : Codable {
    let id : Int
    let results : [MovieVideoResultResponse]
    
}

struct MovieVideoResultResponse : Codable {
    let id : String?
    let iso_639_1 : String?
    let iso_3166_1 : String?
    let key : String?
    let name : String?
    let site : String?
    let size : Int?
    let type : String?
}
