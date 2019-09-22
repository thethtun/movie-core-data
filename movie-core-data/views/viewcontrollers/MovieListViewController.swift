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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    var movies = [MovieInfoResponse]()
    var movieVO = [MovieVO]()
    
    let TAG : String = "MovieListViewController"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        //Remove all cached data in URL Response
        URLCache.shared.removeAllCachedResponses()

        initGenreListFetchRequest()

        initMovieListFetchRequest()
        
    }
    
    fileprivate func initGenreListFetchRequest() {
        //TODO : Fetch Genre List
    }
    
    fileprivate func initMovieListFetchRequest() {
        //FetchRequest
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        //TODO : Fetch & Display Movie Info
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Movie List"
    }

    private func initView() {
        
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.backgroundColor = Theme.background
        
        //Add RefreshControl
        self.collectionViewMovieList.addSubview(refreshControl)
        
    }
    
    
    fileprivate func fetchTopRatedMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        MovieModel.shared.fetchTopRatedMovies(pageId: 1) { [weak self] data in
            
            data.forEach({ (movieInfo) in
                MovieInfoResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
            })
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            
        }
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.fetchTopRatedMovies()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieVO.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movieVO[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        print("Genre Count : \(movie.genres?.count ?? 0)")
        
        cell.data = movie
        return cell
    }
}

extension MovieListViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            
            if let indexPaths = collectionViewMovieList.indexPathsForSelectedItems, indexPaths.count > 0 {
                let selectedIndexPath = indexPaths[0]
                let movie = movieVO[selectedIndexPath.row]
                movieDetailsViewController.movieId = Int(movie.id)
                
                self.navigationItem.title = movie.original_title
            }
            
        }
    }
}


extension MovieListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}



