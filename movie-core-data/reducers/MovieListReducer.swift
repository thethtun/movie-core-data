//
//  MovieListReducer.swift
//  movie-core-data
//
//  Created by Thet Htun on 4/17/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import ReSwift

func movieReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case _ as FetchMoviesSuccess:
        state.isLoading = false
        state.isNetworkSuccess = true
    case let actionCast as FetchMoviesFailed:
        state.isLoading = false
        state.isNetworkSuccess = false
        state.errorMsg = actionCast.err
    case let actionCast as FetchMovieDetailsSuccess:
        state.isLoading = false
        state.isNetworkSuccess = true
        state.movieDetail = actionCast.data
    case let actionCast as NetworkFetchFailed:
        state.isLoading = false
        state.isNetworkSuccess = false
        state.errorMsg = actionCast.err
    case _ as ShowLoading:
        state.isLoading = true
    default:
        break
    }
    
    return state
}


