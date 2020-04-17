//
//  MovieActions.swift
//  movie-core-data
//
//  Created by Thet Htun on 4/17/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import ReSwift
import CoreData

struct FetchMoviesFailed: Action {
    let err : String
}

struct NetworkFetchFailed: Action {
    let err : String
}

struct FetchMoviesSuccess : Action {}

struct FetchMovieDetailsSuccess : Action {
    let data : MovieVO?
}

struct ShowLoading : Action {}
