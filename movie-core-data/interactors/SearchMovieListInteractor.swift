//
//  SearchMovieListInteractor.swift
//  movie-core-data
//
//  Created by Thet Htun on 7/25/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation

class SearchMovieListInteractor: SearchMovieListInteractorProtocol {

    var presenter : SearchMoviePresenterProtocol?
    var movieNetworkClient : MovieNetworkClientAPI?
    var networkUtil : NetworkUtilsAPI?
    
    func searchMovies(name: String) {
        if networkUtil?.checkReachable() == false {
            self.presenter?.view?.showError(msg: "No internet connection!")
        } else {
            self.movieNetworkClient?.searchMoviesByName(movieName: name, completion: { (data) in
                DispatchQueue.main.async {
                    self.presenter?.view?.onMovieFound(data: data)
                }
            })
        }
    }
    
}
