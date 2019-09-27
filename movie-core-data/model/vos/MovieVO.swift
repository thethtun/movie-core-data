//
//  MovieVO.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import RealmSwift

class MovieVO : Object, Codable {
    
    @objc dynamic var popularity : Double = 0
    @objc dynamic var vote_count : Int = 0
    @objc dynamic var video : Bool = false
    @objc dynamic var poster_path : String?
    @objc dynamic var id : Int = 0
    @objc dynamic var adult : Bool = false
    @objc dynamic var backdrop_path : String?
    @objc dynamic var original_language : String?
    @objc dynamic var original_title : String?
    let genre_ids: [Int]
    @objc dynamic var title : String?
    @objc dynamic var vote_average : Double = 0
    @objc dynamic var overview : String?
    @objc dynamic var release_date : String?
//    @objc dynamic var budget : Int = 0
//    @objc dynamic var homepage : String?
//    @objc dynamic var imdb_id : String?
//    @objc dynamic var revenue : Int = 0
//    @objc dynamic var runtime : Int = 0
//    @objc dynamic var tagline : String?
    
    //Production Companies
    
    //Production Countries
    
    //Spoken Languages
    
    //Genres
    
    enum CodingKeys:String,CodingKey {
        case popularity
        case vote_count
        case video
        case poster_path
        case id
        case adult
        case backdrop_path
        case original_language
        case original_title
        case genre_ids
        case title
        case vote_average
        case overview
        case release_date
//        case budget
//        case homepage
//        case imdb_id
//        case revenue
//        case runtime
//        case tagline
    }
    
    override class func ignoredProperties() -> [String] {
        return ["genre_ids"]
    }
    
}
