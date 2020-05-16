//
//  MovieListInteractorTest.swift
//  MovieAppUnitTest
//
//  Created by Thet Htun on 5/16/20.
//  Copyright © 2020 padc. All rights reserved.
//

import XCTest
@testable import movie_core_data

class MovieListInteractorTest: XCTestCase {

    let interactor =  MovieListInteractor()
    let movieListView = MockMovieListView()
    let movieListDataManager = MockMovieListDataManager()
    
    override func setUp() {
        interactor.presenter = MockMovieListPresenter()
        interactor.presenter?.view = movieListView
        interactor.dataManager = movieListDataManager
        interactor.movieNetworkClient = MockMovieNetworkClient()
    }
    
    func test_init() {
        XCTAssertNotNil(interactor)
        XCTAssertNotNil(interactor.presenter)
        XCTAssertNotNil(interactor.dataManager)
        XCTAssertNotNil(interactor.movieNetworkClient)
    }
    
    func test_retrieveGenres_dataManagerNil() {
        interactor.dataManager = nil
        interactor.retrieveGenres()

        XCTAssertNotNil(movieListView.errorMsg)
        XCTAssertEqual(movieListView.errorMsg!, "Failed to instantiate data manager.")
    }
    
    func test_retrieveGenres_genreListEmptyInDB_networkFailed() {
        let networkUtils = MockNetworkUtils()
        networkUtils.checkReachability = false
        
        interactor.networkUtil = networkUtils
        interactor.retrieveGenres()

        XCTAssertNotNil(movieListView.errorMsg)
        XCTAssertEqual(movieListView.errorMsg!, "No internet connection!")
    }
    
    func test_retrieveGenres_genreListEmptyInDB_networkFailed_networkOk() {
        let networkUtils = MockNetworkUtils()
        networkUtils.checkReachability = true
        
        interactor.networkUtil = networkUtils
        interactor.retrieveGenres()
        
        XCTAssertGreaterThan(movieListDataManager.savedGenreList.count, 0)
        XCTAssertEqual(movieListDataManager.savedGenreList.count, 1)
    }
    
}




