//
//  MockMovieListPresenter.swift
//  MovieAppUnitTest
//
//  Created by Thet Htun on 5/16/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import UIKit
import CoreData
@testable import movie_core_data

class MockMovieListPresenter: MovieListPresenterDelegate {
    var view: MovieListViewProtocol?
    
    var interactor: MovieListInteractorProtocol?
    
    var router: MovieListRouterProtocol?
    
    func viewDidLoad() {
        
    }
    
    func fetchMovies() {
        
    }
    
    func refreshMovieList() {
        
    }
    
    func showMovieDetails(viewController: UIViewController, data: NSFetchRequestResult?) {
        
    }
    
    
}
