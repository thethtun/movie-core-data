//
//  MovieGenreResponse.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData

struct MovieGenreResponse : Codable {
    let id : Int
    let name : String
    
    static func saveMovieGenreEntity(data : [MovieGenreResponse], context : NSManagedObjectContext) {
        data.forEach { (resp) in
            
            let entity = MovieGenreVO(context: context)
            entity.id = Int32(resp.id)
            entity.name = resp.name
            
            do {
                try context.save()
            } catch {
                print("failed to save movie genre : \(error.localizedDescription)")
            }
        }
        
        
    }
}
