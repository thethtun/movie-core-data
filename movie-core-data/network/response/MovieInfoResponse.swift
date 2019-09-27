//
//  MovieVO.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    static func saveMovie(data : MovieInfoResponse, realm : Realm) {

        guard let id = data.id, id > 0 else {
            print("failed to save MovieInfoResponse")
            return
        }

        let movie = MovieVO()
        movie.popularity = data.popularity ?? 0.0
        movie.vote_count = data.vote_count ?? 0
        movie.video = data.video ?? false
        movie.poster_path = data.poster_path
        movie.id = data.id ?? 0
        movie.adult = data.adult ?? false
        movie.backdrop_path = data.backdrop_path
        movie.original_language = data.original_language
        movie.original_title = data.original_title

        if let genre_ids = data.genre_ids, !genre_ids.isEmpty {
            genre_ids.forEach{ id in
                if let movieGenreVO = MovieGenreVO.getMovieGenreVOById(realm: realm, genreId: id) {
                    movie.genres.append(movieGenreVO)
                }
                
            }
        }
        
        movie.title = data.title
        movie.vote_average = data.vote_average ?? 0.0
        movie.overview = data.overview
        movie.release_date = data.release_date
        movie.budget = data.budget ?? 0
        movie.homepage = data.homepage
        movie.imdb_id = data.imdb_id
        movie.revenue = data.revenue ?? 0
        movie.runtime = data.runtime ?? 0
        movie.tagline = data.tagline


        do {
            try realm.write {
                realm.add(movie)
            }
        } catch {
            print("failed to save movie : \(error.localizedDescription)")
        }
        
    }
    
//    static func updateMovieEntity(existingData movieEntity: MovieVO,newData data : MovieInfoResponse, context : NSManagedObjectContext) {
//        
//        movieEntity.popularity = data.popularity ?? 0.0
//        movieEntity.vote_count = Int32(data.vote_count ?? 0)
//        movieEntity.video = data.video ?? false
//        movieEntity.poster_path = data.poster_path
//        movieEntity.id = Int32(data.id ?? 0)
//        movieEntity.adult = data.adult ?? false
//        movieEntity.backdrop_path = data.backdrop_path
//        movieEntity.original_language = data.original_language
//        movieEntity.original_title = data.original_title
//        movieEntity.title = data.title
//        movieEntity.vote_average = data.vote_average ?? 0.0
//        movieEntity.overview = data.overview
//        movieEntity.release_date = data.release_date
//        movieEntity.budget = Int32(data.budget ?? 0)
//        movieEntity.homepage = data.homepage
//        movieEntity.imdb_id = data.imdb_id
//        movieEntity.revenue = Int32(data.revenue ?? 0)
//        movieEntity.runtime = Int16(data.runtime ?? 0)
//        movieEntity.tagline = data.tagline
//        
//        
//        do {
//            try context.save()
//        } catch {
//            print("failed to update movie : \(error.localizedDescription)")
//        }
//        
//        
//    }

    static func convertToMovieVO(data : MovieInfoResponse, realm : Realm) -> MovieVO {
        
        let movieVO = MovieVO()
        
        movieVO.popularity = data.popularity ?? 0.0
        movieVO.vote_count = data.vote_count ?? 0
        movieVO.video = data.video ?? false
        movieVO.poster_path = data.poster_path
        movieVO.id = data.id ?? 0
        movieVO.adult = data.adult ?? false
        movieVO.backdrop_path = data.backdrop_path
        movieVO.original_language = data.original_language
        movieVO.original_title = data.original_title
        
        
        if let genre_ids = data.genre_ids, !genre_ids.isEmpty {
            movieVO.genres.removeAll()
            genre_ids.forEach{ id in
                if let movieGenreVO = MovieGenreVO.getMovieGenreVOById(realm: realm, genreId: id) {
                    movieVO.genres.append(movieGenreVO)
                }
            }
        }
        
        
        movieVO.title = data.title
        movieVO.vote_average = data.vote_average ?? 0.0
        movieVO.overview = data.overview
        movieVO.release_date = data.release_date
        movieVO.budget = data.budget ?? 0
        movieVO.homepage = data.homepage
        movieVO.imdb_id = data.imdb_id
        movieVO.revenue = data.revenue ?? 0
        movieVO.runtime = data.runtime ?? 0
        movieVO.tagline = data.tagline
        
        
        return movieVO
    }
    
}
