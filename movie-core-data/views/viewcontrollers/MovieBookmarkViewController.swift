//
//  MovieBookmarkViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/24/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import RealmSwift

class MovieBookmarkViewController: UIViewController {

    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    
    let realm = try! Realm()
    
    var bookmarkListToken : NotificationToken?
    var bookmarkList  : Results<BookmarkVO>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    fileprivate func initView() {
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.backgroundColor = Theme.background
        
        //TODO: Implment Realm BookmarkVO observer

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Saved Movies"
    }

}



extension MovieBookmarkViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookmarkVO = bookmarkList?[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.data = bookmarkVO?.movieDetails

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
                let bookmarkVO = bookmarkList?[selectedIndexPath.row]
                let movie = bookmarkVO?.movieDetails

                if let movie = movie, movie.id > 0 {
                    movieDetailsViewController.movieId = Int(movie.id)

                    self.navigationItem.title = movie.original_title
                }

            }

        }
    }
}


extension MovieBookmarkViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}
