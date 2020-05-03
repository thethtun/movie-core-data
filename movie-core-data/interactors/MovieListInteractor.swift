//
//  MovieListInteractor.swift
//  movie-core-data
//
//  Created by Thet Htun on 5/3/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

class MovieListInteractor: MovieListInteractorProtocol {
    
    var presenter : MovieListPresenterDelegate?
    var dataManager : MovieListDataManagerProtocol?
    var movieNetworkClient : MovieNetworkClientAPI?
    
    func retrieveGenres() {
        if let genreList = dataManager?.retrieveGenres() {
            if genreList.isEmpty {
                if NetworkUtils.checkReachable() == false {
                    self.presenter?.view?.showError(msg: "No internet connection!")
                } else {
                    movieNetworkClient?.fetchMovieGenres(completion: { (data) in
                        
                        self.dataManager?.saveGenres(data: data)
                    })
                }
            } else {
                //??
            }
        } else {
            //TODO: data manager is null => show prompt appropriately.
            self.presenter?.view?.showError(msg: "Failed to instantiate data manager.")
        }
    }
    
    func retrieveMovies() {
        self.presenter?.view?.showLoading()
        
        if let movieList = dataManager?.retrieveMovies() {
            if movieList.isEmpty {
                if NetworkUtils.checkReachable() == false {
                    self.presenter?.view?.stopLoading()
                    self.presenter?.view?.showError(msg: "No internet connection!")
                } else {
                    movieNetworkClient?.fetchMovieList(completion: { (data) in
                        self.dataManager?.saveMovies(data: data)
                        
                        //Make sure to switch thread before presenting UI
                        DispatchQueue.main.async {
                            self.presenter?.view?.stopLoading()
                        }
                    })
                }
                
            } else {
                //TODO: update UI for empty list
                self.presenter?.view?.stopLoading()
            }
        } else {
            //TODO: data manager is null => show prompt appropriately.
            self.presenter?.view?.stopLoading()
            self.presenter?.view?.showError(msg: "Failed to instantiate data manager.")
        }
    }
}
