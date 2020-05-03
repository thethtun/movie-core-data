//
//  MovieListRouter.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import UIKit

class MovieListRouter: MovieListRouterProtocol {
    
    func navigateToMovieDetailsViewControlelr() {
        
    }
    
    static func createMovieListViewController() -> UINavigationController {
        let navVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: MovieListViewController.self)) as! UINavigationController
        let movieListVC = navVC.viewControllers[0] as! MovieListViewController
        
        let presenter = MovieListPresenter()
        let interactor = MovieListInteractor()
        let router = MovieListRouter()
        
        interactor.presenter = presenter
        interactor.dataManager = MovieListDataManager()
        interactor.movieNetworkClient = MovieNetworkClient()
        
        presenter.interactor = interactor
        presenter.view = movieListVC
        presenter.router = router

        movieListVC.presenter = presenter
        
        return navVC
    }
    
    
}