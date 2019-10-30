//
//  UserProfileViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class UserProfileViewController: UIViewController {

    @IBOutlet weak var labelUserName : UILabel!
    @IBOutlet weak var viewpodRatedMoviesList : MovieListView!
    @IBOutlet weak var viewpodWatchListMovies : MovieListView!
    
    let sessionId = UserDefaultsManager.sessionId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        fetchRequiredData()
    }
    
    private func initView() {
        
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        
        viewpodRatedMoviesList.movieListTitle = "You Rated these films"
        viewpodRatedMoviesList.onClickItem = { data in
            Navigator.navigateToMovieDetailScreen(viewController: self, data: data)
        }
        viewpodRatedMoviesList.fetchResultController = FetchResultControllerManager.fetchResultsController_ratedMovies()
        
        viewpodWatchListMovies.movieListTitle = "Your WatchList"
        viewpodWatchListMovies.onClickItem = { data in
            Navigator.navigateToMovieDetailScreen(viewController: self, data: data)
        }
        viewpodWatchListMovies.fetchResultController = FetchResultControllerManager.fetchResultsController_watchListMovies()
        
        
    }
    
    private func fetchRequiredData() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        
        fetchUserDetails()
        
        fetchRatedMovies()
        
        fetchWatchListMovies()
        
    }
    
    private func fetchUserDetails() {
        let loader = LoadingIndicator(viewController: self)
        UserModel.shared.fetchAccountDetails(sessionId: sessionId) { [weak self] (data) in
            if let data = data {
                DispatchQueue.main.async {
                    self?.bindUserDetailsInfo(data: data)
                    loader.stopLoading()
                }
            }
        }
    }
    
    private func fetchRatedMovies() {
        RatedMovieVO.deleteAll()
        
        UserModel.shared.fetchRatedMovies(sessionId: sessionId) { (data) in
            data?.results.forEach({ (movieInfo) in
                RatedMovieVO.save(movieId: movieInfo.id ?? 0, context: CoreDataStack.shared.viewContext)
                MovieInfoResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
            })
        }
    }
    
    private func fetchWatchListMovies() {
        WatchListMovieVO.deleteAll()
        
        UserModel.shared.fetchWatchListMovies(sessionId: sessionId) { (data) in
            data?.results.forEach({ (movieInfo) in
                WatchListMovieVO.save(movieId: movieInfo.id ?? 0, context: CoreDataStack.shared.viewContext)
                MovieInfoResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
            })
        }
    }
    
    private func bindUserDetailsInfo(data : UserAccountResponse) {
        self.labelUserName.text = data.username
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Profile"
    }
    
    @IBAction func onClickLogOut(_ sender : Any) {
        
        let loader = LoadingIndicator(viewController: self)
        AuthModel.shared.logOutSession(sessionId: sessionId) { [weak self] (data) in
            
            UserDefaultsManager.clearAll()
            
            DispatchQueue.main.async {
                RatedMovieVO.deleteAll()
                WatchListMovieVO.deleteAll()
                
                loader.stopLoading()
                self?.displayLoggedInScreen()
            }
            
        }
    }
    
    func displayLoggedInScreen() {
        if let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.navigationController?.setViewControllers([loginViewController], animated: true)
        }
    }

}
