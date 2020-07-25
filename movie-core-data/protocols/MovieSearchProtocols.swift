//
//  MovieSearchProtocol.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import UIKit

protocol SearchMovieListInteractorProtocol {
    func searchMovies(name : String)
}

protocol SearchMoviePresenterProtocol {
    var view : SearchMovieViewProtocol? { get set }
    var router : SearchMovieRouterProtocol? { get set }
    var interactor : SearchMovieListInteractorProtocol? { get set }
    func searchMovie(name : String)
}

protocol SearchMovieViewProtocol {
    func showError(msg : String)
    func showLoading()
    func stopLoading()
    func onMovieFound(data: [MovieInfoResponse])
}

protocol SearchMovieRouterProtocol {
    static func createVC() -> UINavigationController
}
