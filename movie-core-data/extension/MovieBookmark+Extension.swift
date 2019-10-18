//
//  MovieBookmark+Extension.swift
//  movie-core-data
//
//  Created by Riki on 9/25/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

extension MovieBookmarkVO {
    static func getMovieVOById(movieId : Int32) -> MovieVO? {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", movieId)
        fetchRequest.predicate = predicate
        
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data[0]
        } catch {
            print("Failed to fetch movie vo from bookmark\(error.localizedDescription)")
            return nil
        }
        
    }
    
    static func getBookmarkedMovies()->[MovieVO]? {
        let fetchRequest : NSFetchRequest<MovieBookmarkVO> = MovieBookmarkVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty{
                return nil
            }
            var bookmarkedMovies = [MovieVO]()
            data.forEach { (bookmarkedMovie) in
                let movieId = bookmarkedMovie.id
                bookmarkedMovies.append(getMovieVOById(movieId: movieId)!)
            }
            return bookmarkedMovies
        } catch {
            print("GetBookmarkedMoves: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func isBookmarked(movieId: Int)->Bool{
        let fetchRequest : NSFetchRequest<MovieBookmarkVO> = MovieBookmarkVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", Int32(movieId))
        fetchRequest.predicate = predicate
        do{
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            return data.count > 0
        } catch {
            print("isBookmarked: \(error.localizedDescription)")
            return false
        }
    }
    
    static func getFetchRequest()->NSFetchRequest<MovieBookmarkVO>{
        let fetchRequest : NSFetchRequest<MovieBookmarkVO> = MovieBookmarkVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
}
