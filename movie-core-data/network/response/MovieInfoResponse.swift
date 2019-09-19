//
//  MovieVO.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

struct MovieInfoResponse : Codable {
    
    let popularity : Double?
    let vote_count : Int?
    let video : Bool?
    let poster_path : String?
    let id : Int?
    let adult : Bool?
    let backdrop_path : String?
    let original_language : String?
    let original_title : String?
    let genre_ids: [Int]?
    let title : String?
    let vote_average : Double?
    let overview : String?
    let release_date : String?
    let budget : Int?
    let homepage : String?
    let imdb_id : String?
    let revenue : Int?
    let runtime : Int?
    let tagline : String?
    
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
        case budget
        case homepage
        case imdb_id
        case revenue
        case runtime
        case tagline = "tagline"
    }
    
    static func saveMovieEntity(data : MovieInfoResponse, context : NSManagedObjectContext) {
        
        guard let id = data.id, id > 0 else {
            print("failed to save MovieInfoResponse")
            return
        }
        
        let movieEntity = MovieVO(context: context)
        movieEntity.popularity = data.popularity ?? 0.0
        movieEntity.vote_count = Int32(data.vote_count ?? 0)
//        movieEntity.video = data.video
        movieEntity.poster_path = data.poster_path
        movieEntity.id = Int32(data.id ?? 0)
        movieEntity.adult = data.adult ?? false
        movieEntity.backdrop_path = data.backdrop_path
        movieEntity.original_language = data.original_language
        movieEntity.original_title = data.original_title
//        movieEntity.genre_ids = data.genre_ids
        movieEntity.title = data.title
        movieEntity.vote_average = data.vote_average ?? 0.0
        movieEntity.overview = data.overview
        movieEntity.release_date = data.release_date
        movieEntity.budget = Int32(data.budget ?? 0)
        movieEntity.homepage = data.homepage
        movieEntity.imdb_id = data.imdb_id
        movieEntity.revenue = Int32(data.revenue ?? 0)
        movieEntity.runtime = Int16(data.runtime ?? 0)
        movieEntity.tagline = data.tagline
        
        
        guard let _ = try? context.save() else {
            print("failed to save MovieVO")
            return
        }
        
        
    }
    
}
