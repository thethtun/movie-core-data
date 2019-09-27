//
//  BookmarkVO+Extension.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/24/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

extension BookmarkVO {
    
    static func saveMovieBookmark(movieId : Int, context: NSManagedObjectContext) {
        let entity = BookmarkVO(context: context)
        entity.movie_id = Int32(movieId)
        entity.id = UUID(uuidString: "\(movieId)")
        entity.created_at = Date()
        //
        
        if let movie = MovieVO.getMovieById(movieId: movieId) {
            entity.movie = movie ///save movie to bookmark
            movie.bookmark = entity ///save bookmark to queried movie
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save bookmark : \(error.localizedDescription)")
        }
    }
    
    static func deleteMovieBookmark(movieId : Int, context: NSManagedObjectContext) {
        let fetchRequest : NSFetchRequest<BookmarkVO> = BookmarkVO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movie_id == %d", movieId)

        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                results.forEach{ item in
                    context.delete(item)
                }
                try? context.save()
            }
        } catch {
            print("Failed to fetch bookmark : \(error.localizedDescription)")
        }
    }
    
    static func isMovieBookmarked(movieId : Int, context : NSManagedObjectContext) -> Bool {
        let fetchRequest : NSFetchRequest<BookmarkVO> = BookmarkVO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                return false
            } else {
                return true
            }
        } catch {
            print("Failed to fetch bookmark : \(error.localizedDescription)")
            
            return false
        }
        
    }
    
    
    static func getAllBookmarkedMovies(context: NSManagedObjectContext) -> [MovieVO] {
        let fetchRequest : NSFetchRequest<BookmarkVO> = BookmarkVO.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
        
            results.forEach{ movieId in
                
            }
            return [MovieVO]()
        } catch {
            print("Failed to fetch bookmark : \(error.localizedDescription)")
            return [MovieVO]()
        }

    }
    
    
}
