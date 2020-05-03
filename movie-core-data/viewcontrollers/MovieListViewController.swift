//
//  ViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    
    var presenter: MovieListPresenterDelegate?
    
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
        
        presenter?.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Movie List"
    }
    
    private func initView() {
        
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.register(MovieItemsCollectionViewCell.self, forCellWithReuseIdentifier: MovieItemsCollectionViewCell.identifier)
        
        //Add RefreshControl
        self.collectionViewMovieList.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.presenter?.refreshMovieList()
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
            self.presenter?.showMovieDetails(viewController: self, data: data)
        }
        return cell
    }
}

extension MovieListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 230)
    }
}

extension MovieListViewController : MovieListViewProtocol {
    
    func showError(msg: String) {
        Dialog.showAlert(viewController: self, title: "Error", message: msg)
    }
    
    func showLoading() {
        self.refreshControl.beginRefreshing()
    }
    
    func stopLoading() {
        self.refreshControl.endRefreshing()
    }
    
}
