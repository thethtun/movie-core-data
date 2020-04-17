//
//  Genre.swift
//  movie-core-data
//
//  Created by Thet Htun on 4/17/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import ReSwiftThunk

let fetchMovieGenresFromNetwork = Thunk<AppState> { (dispatch, getState) in
    MovieModel.shared.fetchMovieGenres { (genreInfoResponse) in
        MovieGenreResponse.saveMovieGenreEntity(data: genreInfoResponse, context: CoreDataStack.shared.viewContext)
    }
}

