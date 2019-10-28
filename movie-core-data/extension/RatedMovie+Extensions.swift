//
//  RatedMovieVO+Extension.swift
//  movie-core-data
//
//  Created by Riki on 9/25/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

extension RatedMovieVO {
    static func save(movieId : Int, context : NSManagedObjectContext) {
        let entity = RatedMovieVO(context: context)
        entity.movie_id = Int32(movieId)
        entity.id = UUID(uuidString: "\(movieId)")
        entity.created_at = Date()
        
        do {
            try context.save()
        } catch {
            print("failed to save rated movie")
        }
    }
    
    static func delete(movieId : Int, context: NSManagedObjectContext) {
        let fetchRequest : NSFetchRequest<RatedMovieVO> = RatedMovieVO.fetchRequest()
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
            print("Failed to fetch rated movie : \(error.localizedDescription)")
        }
    }
    
    static func deleteAll() {
        let fetchRequest : NSFetchRequest<RatedMovieVO> = RatedMovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let data = try? CoreDataStack.shared.viewContext.fetch(fetchRequest), !data.isEmpty {
            data.forEach { movie in
                CoreDataStack.shared.viewContext.delete(movie)
                
            }
            try? CoreDataStack.shared.viewContext.save()
        }
        
    }
    
    static func isMovieRated(movieId : Int, context : NSManagedObjectContext) -> Bool {
        let fetchRequest : NSFetchRequest<RatedMovieVO> = RatedMovieVO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "movie_id == %d", movieId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                return false
            } else {
                return true
            }
        } catch {
            print("Failed to fetch rated movie : \(error.localizedDescription)")
            
            return false
        }
    }
    
    static func getAllRatedMovies(context: NSManagedObjectContext) -> [MovieVO?] {
        let fetchRequest : NSFetchRequest<RatedMovieVO> = RatedMovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(fetchRequest)
            
            var list = [MovieVO?]()
            results.forEach{ ratedMovie in
                list.append(MovieVO.getMovieById(movieId: Int(ratedMovie.movie_id)))
            }
            
            return list
        } catch {
            print("Failed to fetch rated movie : \(error.localizedDescription)")
            return [MovieVO]()
        }
        
    }
}
