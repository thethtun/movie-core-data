//
//  FetchRequestManager.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

class FetchResultControllerManager {
    static func fetchResultsController_allMovies() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    static func fetchResultsController_ratedMovies() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest<RatedMovieVO> = RatedMovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    static func fetchResultsController_watchListMovies() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest<WatchListMovieVO> = WatchListMovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    static func fetchResultsController_nowPlaying() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let predicate = NSPredicate(format: "movie_tag == %@", MovieTag.NOW_PLAYING.rawValue)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    static func fetchResultsController_upcoming() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let predicate = NSPredicate(format: "movie_tag == %@", MovieTag.UPCOMING.rawValue)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    static func fetchResultsController_popular() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let predicate = NSPredicate(format: "movie_tag == %@", MovieTag.POPULAR.rawValue)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    static func fetchResultsController_topRated() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let predicate = NSPredicate(format: "movie_tag == %@", MovieTag.TOP_RATED.rawValue)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    static func getFetchResultsControllerByMovieTag(tag : MovieTag) -> NSFetchedResultsController<NSFetchRequestResult> {
        switch tag {
        case .NOW_PLAYING:
            return fetchResultsController_nowPlaying()
        case .POPULAR:
            return fetchResultsController_popular()
        case .TOP_RATED:
            return fetchResultsController_topRated()
        case .UPCOMING:
            return fetchResultsController_upcoming()   
        default:
            return fetchResultsController_nowPlaying()
            
        }
    }
}
