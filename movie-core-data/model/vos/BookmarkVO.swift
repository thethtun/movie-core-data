//
//  BookmarkVO.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/27/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import RealmSwift

class BookmarkVO : Object {
    @objc dynamic var id : String = UUID().uuidString
    @objc dynamic var movie_id : Int = 0
    @objc dynamic var created_at = Date()
    @objc dynamic var movieDetails : MovieVO?
    
    override class func primaryKey() -> String? {
        return "movie_id"
    }
}


extension BookmarkVO {
    static func saveMovieBookmark(movieId : Int, realm : Realm) {
        
        //TODO: Implment save method for Realm Object BookmarkVO
        
    }
    
    static func deleteMovieBookmark(movieId : Int, realm : Realm) {
        
        //TODO: Implment delete method for Realm Object BookmarkVO
        
    }
}
