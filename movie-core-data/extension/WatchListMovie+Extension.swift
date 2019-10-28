//
//  WatchListMovie+Extension.swift
//  movie-core-data
//
//  Created by Riki on 9/25/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

extension WatchListMovieVO {
    static func save(movieId : Int, context : NSManagedObjectContext) {
        let entity = WatchListMovieVO(context: context)
        entity.movie_id = Int32(movieId)
        entity.id = UUID(uuidString: "\(movieId)")
        entity.created_at = Date()
        
        do {
            try context.save()
        } catch {
            print("failed to save watchList movie")
        }
    }
    
    static func delete(movieId : Int, context: NSManagedObjectContext) {
        let fetchRequest : NSFetchRequest<WatchListMovieVO> = WatchListMovieVO.fetchRequest()
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
            print("Failed to fetch watchList movie : \(error.localizedDescription)")
        }
    }
    
    static func deleteAll() {
        let fetchRequest : NSFetchRequest<WatchListMovieVO> = WatchListMovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let data = try? CoreDataStack.shared.viewContext.fetch(fetchRequest), !data.isEmpty {
            data.forEach { movie in
                CoreDataStack.shared.viewContext.delete(movie)
                
            }
            try? CoreDataStack.shared.viewContext.save()
        }
        
    }
    
    static func isMoviewatchList(movieId : Int, context : NSManagedObjectContext) -> Bool {
        let fetchRequest : NSFetchRequest<WatchListMovieVO> = WatchListMovieVO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movie_id == %d", movieId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                return false
            } else {
                return true
            }
        } catch {
            print("Failed to fetch watchList movie : \(error.localizedDescription)")
            
            return false
        }
    }
    
    static func getAllWatchListMovies(context: NSManagedObjectContext) -> [MovieVO?] {
        let fetchRequest : NSFetchRequest<WatchListMovieVO> = WatchListMovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(fetchRequest)
            
            var list = [MovieVO?]()
            results.forEach{ WatchListMovie in
                list.append(MovieVO.getMovieById(movieId: Int(WatchListMovie.movie_id)))
            }
            
            return list
        } catch {
            print("Failed to fetch watchList movie : \(error.localizedDescription)")
            return [MovieVO]()
        }
        
    }
}
