//
//  MovieListProtocols.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import UIKit
import CoreData

protocol MovieListRouterProtocol: class{
    static func createMovieListViewController() -> UINavigationController
    func navigateToMovieDetailsViewControlelr(viewController : UIViewController, data : NSFetchRequestResult?)
}

protocol MovieListPresenterDelegate {
    var view : MovieListViewProtocol? { get set }
    var interactor : MovieListInteractorProtocol? { get set }
    var router : MovieListRouterProtocol? { get set }
    func viewDidLoad()
    func fetchMovies()
    func refreshMovieList()
    func showMovieDetails(viewController : UIViewController, data : NSFetchRequestResult?)
    
}

protocol MovieListViewProtocol:class {
    func showError(msg : String)
    func showLoading()
    func stopLoading()
}

protocol MovieListInteractorProtocol:class {
    func retrieveMovies()
    func retrieveGenres()
}

protocol MovieListDataManagerProtocol:class {
    func retrieveMovies() -> [MovieVO]
    func retrieveGenres() -> [MovieGenreVO]
    func saveMovies(data: [MovieInfoResponse])
    func saveGenres(data: [MovieGenreResponse]) 
}
