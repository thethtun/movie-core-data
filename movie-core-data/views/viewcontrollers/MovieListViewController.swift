//
//  ViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/17/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import RealmSwift

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    
    let TAG : String = "MovieListViewController"
    
    let realm = try! Realm(configuration: Realm.Configuration(
        schemaVersion: 2,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 2) {
//                migration.enumerateObjects(ofType: ContactVO.className(), { oldObject, newObject in
//                        //Migration Script
//                })
            }
    }))
    
    var movieList : Results<MovieVO>?
    
    private var movieListNotifierToken : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        //Remove all cached data in URL Response
        URLCache.shared.removeAllCachedResponses()

        initGenreListFetchRequest()

        initMovieListFetchRequest()
        
    }
    
    fileprivate func initGenreListFetchRequest() {
        let genres = realm.objects(MovieGenreVO.self)
        if genres.isEmpty {
            MovieModel.shared.fetchMovieGenres{ genres in
                genres.forEach { [weak self] genre in
                    DispatchQueue.main.async {
                        MovieGenreResponse.saveMovieGenre(data: genre, realm: self!.realm)
                    }
                }
            }
        }
        
    }
    
    fileprivate func initMovieListFetchRequest() {
        movieList = realm.objects(MovieVO.self).sorted(byKeyPath: "vote_average", ascending: false)
        if movieList!.isEmpty {
            self.fetchTopRatedMovies()
        }
        
        movieListNotifierToken = movieList!._observe{ [weak self] changes in
            switch changes {
            case .initial:
                self?.collectionViewMovieList.reloadData()
                break
            case .update(_,let deletions,let insertions,let modification):
                self?.collectionViewMovieList.performBatchUpdates({
                    self?.collectionViewMovieList.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
                    self?.collectionViewMovieList.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    self?.collectionViewMovieList.reloadItems(at: modification.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
                
                break
            case .error(let error):
                fatalError("\(error)")
            }
            
        }
        
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
        MovieModel.shared.fetchTopRatedMovies(pageId: 1) { [weak self] movies in
            DispatchQueue.main.async { [weak self] in
                
                movies.forEach{ movie in
                    MovieInfoResponse.saveMovie(data: movie, realm: self!.realm)
                }
                
                
                self?.refreshControl.endRefreshing()
            }
            
            
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        if let movieList = movieList, !movieList.isEmpty {
            movieList.forEach{ movie in
                try! realm.write {
                    print("Deleting \(movie.original_title ?? "xxx")" )
                    realm.delete(movie)
                }
            }
            
            self.fetchTopRatedMovies()
        }
        
        
    }
    
    
    deinit {
        movieListNotifierToken?.invalidate()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movieList?[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }

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
                let movie = movieList![selectedIndexPath.row]
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



