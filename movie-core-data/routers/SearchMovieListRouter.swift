//
//  SearchMovieListRouter.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import UIKit

class SearchMovieListRouter: SearchMovieRouterProtocol {
    static func createVC() -> UINavigationController {
        let navVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: SearchMovieViewController.self)) as! UINavigationController
        let viewController = navVC.viewControllers[0] as! SearchMovieViewController
        
        let presenter = SearchMovieListPresenter()
        let interactor = SearchMovieListInteractor()
        let router = SearchMovieListRouter()
        
        interactor.presenter = presenter
        interactor.movieNetworkClient = MovieNetworkClient()
        interactor.networkUtil = NetworkUtils()
        
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.router = router

        viewController.presenter = presenter
        
        return navVC
    }
    
}
