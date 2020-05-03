//
//  MovieListPresenter.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

class MovieListPresenter: MovieListPresenterDelegate {
    
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInteractorProtocol?
    var router : MovieListRouterProtocol?
    
    func viewDidLoad() {
        interactor?.retrieveGenres()
        interactor?.retrieveMovies()
    }
    
    func fetchMovies() {
        interactor?.retrieveMovies()
    }
    
    func refreshMovieList() {
        MovieVO.deleteAllMovies()
        interactor?.retrieveMovies()
    }
}
