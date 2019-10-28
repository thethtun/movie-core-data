//
//  BookmarkViewController.swift
//  movie-core-data
//
//  Created by Riki on 9/28/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var collectionViewBookmark: UICollectionView!
    
    var fetchResultController: NSFetchedResultsController<MovieBookmarkVO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Bookmarks"
    }
    
    fileprivate func initView(){
        fetchBookmarks()
        collectionViewBookmark.dataSource = self
        collectionViewBookmark.delegate = self
        collectionViewBookmark.backgroundColor = Theme.background
    }
    
    fileprivate func fetchBookmarks(){
        let fetchRequest: NSFetchRequest<MovieBookmarkVO> = MovieBookmarkVO.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do{
            try fetchResultController.performFetch()
        } catch {
            print("FetchBookmarks: \(error.localizedDescription)")
        }
    }
    
}
extension BookmarkViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchResultController.sections?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultController.sections![section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookmark = fetchResultController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as! BookmarkCollectionViewCell
        cell.data = MovieBookmarkVO.getMovieVOById(movieId: bookmark.id)
        return cell
    }
}
extension BookmarkViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let detailVC = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.identifier) as? MovieDetailsViewController
        //        if let vc = detailVC {
        //            let movieId = Int(fetchResultController.object(at: indexPath).id)
        //            vc.movieId = movieId
        //            let movie = MovieVO.getMovieById(movieId: movieId)
        //            vc.navigationItem.title = movie?.original_title ?? ""
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            if let indexPaths = collectionViewBookmark.indexPathsForSelectedItems, indexPaths.count > 0 {
                let selectedIndexPath = indexPaths[0]
                let movieId = Int(fetchResultController.object(at: selectedIndexPath).id)
                let movie = MovieVO.getMovieById(movieId: movieId)
                print(movieId)
                print(movie?.original_title ?? "NoTitle")
                movieDetailsViewController.movieId = movieId
                self.navigationItem.title = movie?.original_title ?? ""
            }
        }
    }
}
extension BookmarkViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}

extension BookmarkViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionViewBookmark.reloadData()
    }
}
