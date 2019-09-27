//
//  MovieListByGenreViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/21/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import RealmSwift

class MovieListByGenreViewController: UIViewController {

    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    
    var movieGenreVO : MovieGenreVO?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    fileprivate func initView() {
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.backgroundColor = Theme.background
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = ""
    }
    
}

extension MovieListByGenreViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieGenreVO?.movies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = movieGenreVO?.movies[indexPath.row]
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
                let movie = movieGenreVO?.movies[selectedIndexPath.row]
                movieDetailsViewController.movieId = Int(movie?.id ?? 0)

                self.navigationItem.title = movie?.original_title ?? ""
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
