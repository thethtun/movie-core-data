//
//  MovieGenre.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import RealmSwift

class MovieGenreVO : Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = ""
    let movies = LinkingObjects(fromType: MovieVO.self, property: "genres")
    
    
    //TODO: Set "id" as primary key
    
}


extension MovieGenreVO {
    static func getMovieGenreVOById(realm : Realm, genreId : Int) -> MovieGenreVO? {
        //TODO: Implement Realm Fetch Request for MovieGenreVO by genreID
        return nil
    }
}
