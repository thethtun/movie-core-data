//
//  SearchMovieListPresenter.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

class SearchMovieListPresenter: SearchMoviePresenterProtocol {
    
    var view: SearchMovieViewProtocol?
    
    var router: SearchMovieRouterProtocol?
    
    var interactor: SearchMovieListInteractorProtocol?
    
    func searchMovie(name : String) {
        interactor?.searchMovies(name: name)
    }
}
