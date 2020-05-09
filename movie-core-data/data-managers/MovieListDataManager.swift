//
//  MovieListDataManager.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import CoreData

class MovieListDataManager : MovieListDataManagerProtocol {
   

    private let dbContext = CoreDataStack.shared.viewContext
    
    func retrieveGenres() -> [MovieGenreVO] {
        let fetchRequest: NSFetchRequest<MovieGenreVO> = MovieGenreVO.fetchRequest()
        
        do{
            let genres = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            return genres
        } catch {
            print("TAG: \(error.localizedDescription)")
            return []
        }
    }
    
    func retrieveMovies() -> [MovieVO] {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let data = try dbContext.fetch(fetchRequest)
            return data
        } catch {
            print("\(error.localizedDescription)")
            return []
        }
    }
    
    func saveGenres(data: [MovieGenreResponse]) {
        MovieGenreResponse.saveMovieGenreEntity(data: data, context: dbContext)
    }
    
    func saveMovies(data : [MovieInfoResponse]) {
        data.forEach({ (movieInfoRes) in
            MovieInfoResponse.saveMovieEntity(data: movieInfoRes, context: dbContext)
        })
    }
}
