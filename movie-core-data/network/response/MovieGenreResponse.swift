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
    
    static func saveMovieGenreEntity(data : MovieGenreResponse, context : NSManagedObjectContext) {
        let entity = MovieGenreVO(context: context)
        entity.id = Int32(data.id)
        entity.name = data.name
        
        do {
            try context.save()
        } catch {
            print("failed to save movie genre : \(error.localizedDescription)")
        }
        
    }
}
