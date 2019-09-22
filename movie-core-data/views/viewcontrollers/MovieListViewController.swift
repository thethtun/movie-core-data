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
    
    var fetchResultController: NSFetchedResultsController<MovieVO>!
    
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
        //FetchRequest
        let fetchRequest : NSFetchRequest<MovieGenreVO> = MovieGenreVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let data = try? CoreDataStack.shared.viewContext.fetch(fetchRequest) {
            if data.isEmpty {
                //Fetch Movie Genre
                MovieModel.shared.fetchMovieGenres{ genreResponses in
                    genreResponses.forEach { genre in
                        MovieGenreResponse.saveMovieGenreEntity(data: genre, context: CoreDataStack.shared.viewContext)
                    }
                }
            } else {
                print("Existing Movie Genre Count : \(data.count)")
            }
        }
    }
    
    fileprivate func initMovieListFetchRequest() {
        //FetchRequest
        let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "movies")
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            if let objects = fetchResultController.fetchedObjects, objects.count == 0 {
                self.fetchTopRatedMovies()
            }
        } catch {
            Dialog.showAlert(viewController: self, title: "Error", message: "Failed to fetch data from database")
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
        MovieModel.shared.fetchTopRatedMovies(pageId: 1) { [weak self] data in
            
            data.forEach({ (movieInfo) in
                MovieInfoResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
            })
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            
        }
    }
    
    @IBAction func onClickAddDummyData(_ sender: Any) {
        let movieVO = fetchResultController.object(at: IndexPath(item: 1, section: 0))
        let movieInfo = MovieInfoResponse(
            popularity: movieVO.popularity,
            vote_count: 0,
            video: movieVO.video,
            poster_path: movieVO.poster_path,
            id: 100,
            adult: movieVO.adult,
            backdrop_path: movieVO.backdrop_path,
            original_language: movieVO.original_language,
            original_title: "",
            genre_ids: nil,
            title: "",
            vote_average: 0.0,
            overview: "", release_date: "", budget: 0, homepage: "", imdb_id: "", revenue: 0, runtime: 0, tagline: "")
        print("dummy data added")
        MovieInfoResponse.saveMovieEntity(data: movieInfo, context: CoreDataStack.shared.viewContext)
        
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if let data = fetchResultController.fetchedObjects, !data.isEmpty {
            data.forEach { movie in
                CoreDataStack.shared.viewContext.delete(movie)
                try? CoreDataStack.shared.viewContext.save()
            }
        }
        
        self.fetchTopRatedMovies()
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchResultController.sections?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = fetchResultController.object(at: indexPath)
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
                let movie = fetchResultController.object(at: selectedIndexPath)
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

extension MovieListViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionViewMovieList.insertItems(at: [newIndexPath!])
            break
        case .delete:
            collectionViewMovieList.deleteItems(at: [indexPath!])
            break
        default:()
        }
    }
    
}



