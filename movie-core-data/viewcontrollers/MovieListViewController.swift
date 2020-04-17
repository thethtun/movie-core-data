//
//  ViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData
import ReSwift

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    
    var movieTags : [MovieTag] = [.UPCOMING, .NOW_PLAYING, .TOP_RATED, .POPULAR]
    
    let TAG : String = "MovieListViewController"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        //Remove all cached data in URL Response
        URLCache.shared.removeAllCachedResponses()
        
        initGenreListFetchRequest()
        
        initMovieListFetchRequest()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Movie List"
        
        //Subscribe to redux store
        mainStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unsubscribe to redux store
        mainStore.unsubscribe(self)
    }
 
    fileprivate func initGenreListFetchRequest() {
        mainStore.dispatch(startGenreListFetchRequest)
    }
    
    private func fetchGenresList() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        mainStore.dispatch(fetchMovieGenresFromNetwork)
    }
    
    fileprivate func initMovieListFetchRequest() {
        mainStore.dispatch(startMovieListFetchRequest)
    }
    

    private func initView() {
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.register(MovieItemsCollectionViewCell.self, forCellWithReuseIdentifier: MovieItemsCollectionViewCell.identifier)
        
        //Add RefreshControl
        self.collectionViewMovieList.addSubview(refreshControl)
    }
    
    fileprivate func fetchMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            self.refreshControl.endRefreshing()
            return
        }
        mainStore.dispatch(fetchMoviesFromNetwork)
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.fetchMovies()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemsCollectionViewCell.identifier, for: indexPath) as? MovieItemsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movieTag = movieTags[indexPath.row]
        let fetchResultController = FetchResultControllerManager.getFetchResultsControllerByMovieTag(tag: movieTag)
        cell.initState(fetchResultController: fetchResultController, movieListTitle: movieTag.rawValue)

        cell.movieListView.onClickItem = { data in
            Navigator.navigateToMovieDetailScreen(viewController: self, data: data)
        }
        return cell
    }
}

extension MovieListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: MovieItemsCollectionViewCell.cellHeight)
    }
}


extension MovieListViewController : StoreSubscriber {
    
     func newState(state: AppState) {
        self.refreshControl.endRefreshing()
        
        if !state.isNetworkSuccess {
            Dialog.showAlert(viewController: self, title: "Error", message: state.errorMsg)
        }
     }
     
}
