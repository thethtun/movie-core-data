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
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let ui = UIActivityIndicatorView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.startAnimating()
        ui.style = UIActivityIndicatorView.Style.whiteLarge
        return ui
    }()
    
    
    let TAG : String = "MovieListViewController"
    
    let realm = try! Realm()
    
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
    
    private func initView() {
        
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.backgroundColor = Theme.background
        collectionViewMovieList.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
     
        //Add RefreshControl
        self.collectionViewMovieList.addSubview(refreshControl)
        
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.startAnimating()
        
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
        
        //TODO: Setup Realm Notification Observer
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Movie List"
    }
    
    
    fileprivate func fetchPopularMovies() {
           if NetworkUtils.checkReachable() == false {
               Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
               return
           }
           
           for index in 0...5 {
               MovieModel.shared.fetchPopularMovies(pageId: index) { [weak self] movies in
                   DispatchQueue.main.async { [weak self] in
                       
                       movies.forEach{ movie in
                           MovieInfoResponse.saveMovie(data: movie, realm: self!.realm)
                       }
                       
                       self?.activityIndicator.stopAnimating()
                       self?.refreshControl.endRefreshing()
                   }
                   
               }
           }
           

       }
    
    
    fileprivate func fetchTopRatedMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        for index in 0...5 {
            MovieModel.shared.fetchTopRatedMovies(pageId: index) { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(data: movie, realm: self!.realm)
                    }
                    
                    self?.activityIndicator.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }
                
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
            
            self.fetchPopularMovies()
        }
        
        
    }
    
   
    
    deinit {
        movieListNotifierToken?.invalidate()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if #available(iOS 13.0, *) {
            // use the feature only available in iOS 9
            // for ex. UIStackView
            return 5
        } else {
            return 1
        }
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: TitleSupplementaryView.reuseIdentifier, for: indexPath) as! TitleSupplementaryView
        
        switch indexPath.section {
        case 0:
            cell.label.text = "Featured Movies"
        case 1:
            cell.label.text = "Upcoming Movies"
        case 2:
            cell.label.text = "Recommended Movies"
        case 3:
            cell.label.text = "Library"
        default:
            cell.label.text = "Section Headers"
        }
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



