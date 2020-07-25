//
//  MovieListPresenter.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import UIKit
import CoreData

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
    
    func showMovieDetails(viewController: UIViewController, data: NSFetchRequestResult?) {
        router?.navigateToMovieDetailsViewControlelr(viewController: viewController, data: data)
    }

}
