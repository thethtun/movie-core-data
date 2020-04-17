//
//  AppState.swift
//  movie-core-data
//
//  Created by Thet Htun on 4/17/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import ReSwift
import CoreData

struct AppState: StateType {
    var movies = [MovieVO]()
    var isNetworkSuccess = true
    var errorMsg = ""
    var isLoading = false
    var movieDetail : MovieVO?
    var similarMovies = [MovieInfoResponse]()
}
