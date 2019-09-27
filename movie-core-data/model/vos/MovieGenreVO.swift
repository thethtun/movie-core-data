//
//  MovieGenre.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import RealmSwift

class MovieGenreVO : Object, Codable {
    @objc dynamic var id : Int
    @objc dynamic var name : String
}
