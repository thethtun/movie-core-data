//
//  MovieBookmark.swift
//  movie-core-data
//
//  Created by Riki on 9/27/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

struct MovieBookmark {
    
    static func saveBookmark(movieId: Int,context: NSManagedObjectContext){
        let entity = MovieBookmarkVO(context: context)
        entity.id = Int32(movieId)
        do{
            try context.save()
        }catch {
            print("SaveBookmark: \(error.localizedDescription)")
        }
    }
    
    static func deleteBookmark(movieId: Int,context: NSManagedObjectContext){
        let fetchRequest : NSFetchRequest<MovieBookmarkVO> = MovieBookmarkVO.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", Int32(movieId))
        fetchRequest.predicate = predicate
        
        do{
            let data = try context.fetch(fetchRequest)
            let bookmarkToDelete = data[0] as NSManagedObject
            context.delete(bookmarkToDelete)
        } catch {
            print("DeleteBookmark: \(error.localizedDescription)")
        }
    }
    
}
