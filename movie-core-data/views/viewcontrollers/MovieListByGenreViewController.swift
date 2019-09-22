//
//  MovieListByGenreViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/21/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class MovieListByGenreViewController: UIViewController {

    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    
    var fetchResultController: NSFetchedResultsController<MovieVO>!
    
    var movieGenreVO : MovieGenreVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initMovieListFetchRequestByeGenre()
    }
    
    fileprivate func initView() {
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.backgroundColor = Theme.background
    }
    
    fileprivate func initMovieListFetchRequestByeGenre() {
        
        guard let genreVO = movieGenreVO  else {
            Dialog.showAlert(viewController: self, title: "Error", message: "Undefined Genre")
            return
        }

        //FetchRequest
        let fetchRequest = MovieVO.getMoviesByGenreFetchRequest(genre: genreVO)

        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "movies_by_genre")

        do {
            try fetchResultController.performFetch()
        } catch {
            Dialog.showAlert(viewController: self, title: "Error", message: "Failed to fetch data from database")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = ""
    }
    
}

extension MovieListByGenreViewController: UICollectionViewDataSource {
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

        cell.data = movie

        return cell
    }
}

extension MovieListByGenreViewController : UICollectionViewDelegate {

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


extension MovieListByGenreViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}
