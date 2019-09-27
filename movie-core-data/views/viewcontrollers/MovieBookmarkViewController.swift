//
//  MovieBookmarkViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/24/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class MovieBookmarkViewController: UIViewController {

    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    
    var fetchResultController: NSFetchedResultsController<BookmarkVO>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    fileprivate func initView() {
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.backgroundColor = Theme.background
        
        //FetchRequest
        let fetchRequest : NSFetchRequest<BookmarkVO> = BookmarkVO.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "created_at", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
        } catch {
            Dialog.showAlert(viewController: self, title: "Error", message: "Failed to fetch data from database")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Saved Movies"
    }

}



extension MovieBookmarkViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchResultController.sections?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookmarkVO = fetchResultController.object(at: indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.data = bookmarkVO.movie
        
        return cell
    }
}

extension MovieBookmarkViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            
            if let indexPaths = collectionViewMovieList.indexPathsForSelectedItems, indexPaths.count > 0 {
                let selectedIndexPath = indexPaths[0]
                let bookmarkVO = fetchResultController.object(at: selectedIndexPath)
                let movie = bookmarkVO.movie
                
                if let movie = movie, movie.id > 0 {
                    movieDetailsViewController.movieId = Int(movie.id)
                    
                    self.navigationItem.title = movie.original_title
                }
                
            }
            
        }
    }
}

extension MovieBookmarkViewController : NSFetchedResultsControllerDelegate {
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


extension MovieBookmarkViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}
