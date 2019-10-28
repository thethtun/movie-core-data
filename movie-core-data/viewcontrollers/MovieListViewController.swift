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
    
    
    fileprivate func initGenreListFetchRequest() {
        //TODO : Fetch Genre List
        let fetchRequest: NSFetchRequest<MovieGenreVO> = MovieGenreVO.fetchRequest()
        
        do{
            let genres = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if genres.isEmpty{
                fetchGenresList()
            }
            
        } catch {
            print("TAG: \(error.localizedDescription)")
        }
    }
    
    private func fetchGenresList() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        MovieModel.shared.fetchMovieGenres { (genreInfoResponse) in
            MovieGenreResponse.saveMovieGenreEntity(data: genreInfoResponse, context: CoreDataStack.shared.viewContext)
        }
    }
    
    
    
    fileprivate func initMovieListFetchRequest() {
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                fetchMovies()
            }
            
        } catch {
            print("\(error.localizedDescription)")
        }

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
    
    fileprivate func fetchMovies() {
        var movieInfoResponses = [MovieInfoResponse]()
        
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            self.refreshControl.endRefreshing()
            return
        }
        
        MovieVO.deleteAllMovies()
        
        MovieModel.shared.fetchTopRatedMovies(pageId: 1) { [weak self] data in
            data.forEach({ (movieInfo) in
                var data = movieInfo
                data.movieTag = MovieTag.TOP_RATED
                movieInfoResponses.append(data)
            })
            
            MovieModel.shared.fetchPopularMovies(pageId: 1) { [weak self] data in
                data.forEach({ (movieInfo) in
                    var data = movieInfo
                    data.movieTag = MovieTag.POPULAR
                    movieInfoResponses.append(data)
                })
                
                MovieModel.shared.fetchUpcomingMovies(pageId: 1) { [weak self] data in
                    data.forEach({ (movieInfo) in
                        var data = movieInfo
                        data.movieTag = MovieTag.UPCOMING
                        movieInfoResponses.append(data)
                    })
                    
                    MovieModel.shared.fetchNowPlaying(pageId: 1) {  data in
                        data.forEach({ (movieInfo) in
                            var data = movieInfo
                            data.movieTag = MovieTag.NOW_PLAYING
                            movieInfoResponses.append(data)
                        })
                        
                        DispatchQueue.main.async {
                            movieInfoResponses.forEach({ (movieInfoRes) in
                                MovieInfoResponse.saveMovieEntity(data: movieInfoRes, context: CoreDataStack.shared.viewContext)
                            })
                            self?.refreshControl.endRefreshing()
                        }
                    }
                }
            }
        }
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
        return CGSize(width: collectionView.bounds.width, height: 230)
    }
}



