//
//  UserProfileViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var viewpodRatedMoviesList : MovieListView!
    @IBOutlet weak var viewpodWatchListMovies : MovieListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        
        viewpodRatedMoviesList.movieListTitle = "You Rated these films"
        viewpodRatedMoviesList.fetchRequestController = FetchRequestControllerManager.fetchResultsController_allMovies()

    }
    

}
