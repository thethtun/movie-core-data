//
//  MockMovieListView.swift
//  MovieAppUnitTest
//
//  Created by Thet Htun on 5/16/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
@testable import movie_core_data

class MockMovieListView: MovieListViewProtocol {
    
    var errorMsg : String?
    var isLoading : Bool = false
    
    func showError(msg: String) {
        errorMsg = msg
    }
    
    func showLoading() {
        isLoading = true
    }
    
    func stopLoading() {
        isLoading = false
    }
    
}
