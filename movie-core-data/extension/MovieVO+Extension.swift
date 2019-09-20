//
//  MovieVO+Extension.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/20/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

extension MovieVO {
    static func fetchMovies() -> [MovieVO]? {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let data = try? CoreDataStack.shared.viewContext.fetch(fetchRequest) {
            return data
        }
        
        return nil
    }
    
    static func getMovieById(movieId : Int) -> MovieVO? {
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
            print("failed to fetch movie with id \(movieId): \(error.localizedDescription)")
            return nil
        }
        
    }
    
    static func getMoviesByGenre(genre : MovieGenreVO) -> [MovieVO]? {
        let fetchRequest = getMoviesByGenreFetchRequest(genre: genre)
        
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data
        } catch {
            print("failed to fetch movie with genre \(genre.name ?? ""): \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getMoviesByGenreFetchRequest(genre : MovieGenreVO) -> NSFetchRequest<MovieVO> {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let predicate = NSPredicate(format: "genres CONTAINS[cd] %@", genre)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
}
