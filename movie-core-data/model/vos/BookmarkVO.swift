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
        
        
        let movieVO = MovieVO.getMovieById(movieId: movieId, realm: realm)
        
        let bookmarkVO = BookmarkVO()
        bookmarkVO.id = UUID().uuidString
        bookmarkVO.created_at = Date()
        bookmarkVO.movieDetails = movieVO
        bookmarkVO.movie_id = movieVO?.id ?? 0
        
        do {
            try realm.write {
                realm.add(bookmarkVO)
            }
        } catch {
            print("Failed to save bookmark \(error.localizedDescription)")
        }
    }
    
    static func deleteMovieBookmark(movieId : Int, realm : Realm) {
        
        let bookmarks = realm.objects(BookmarkVO.self).filter(NSPredicate(format: "id == %d", movieId) )
    
        do {
            try realm.write {
                
                realm.delete(bookmarks)
            }
        } catch {
            print("Failed to save bookmark \(error.localizedDescription)")
        }
    }
}
