//
//  MovieGenreResponse.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift

struct MovieGenreResponse : Codable {
    let id : Int
    let name : String
    
    static func saveMovieGenre(data : MovieGenreResponse, realm: Realm) {
        let entity = MovieGenreVO()
        entity.id = data.id
        entity.name = data.name
        
        do {
            try realm.write {
                realm.add(entity)
            }
        } catch {
            print("failed to save movie genre : \(error.localizedDescription)")
        }
        
    }
}
