//
//  SearchMovieViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/22/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class SearchMovieViewController: UIViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    @IBOutlet weak var labelMovieNotFound : UILabel!
    
    private var searchedResult = [MovieInfoResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Search Movies"
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    fileprivate func initView() {
        // Setup the Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Eg: One upon a time in Hollywood"
        
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
//        searchController.searchBar.searchTextField.textColor = .white
        
        
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.backgroundColor = Theme.background
        collectionViewMovieList.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        
    }
    
}

extension SearchMovieViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = searchedResult[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        
        let movieVO = MovieInfoResponse.convertToMovieVO(data: movie, context: CoreDataStack.shared.viewContext)
        
        cell.data = movieVO
        
        return cell
    }
    
    func bindData(_ results : [MovieInfoResponse]) {
        DispatchQueue.main.async { [weak self] in
            if results.isEmpty {
                self?.labelMovieNotFound.text = "No movie found :("
                return
            }
            self?.searchedResult = results
            self?.labelMovieNotFound.text = ""
            self?.collectionViewMovieList.reloadData()
        }
    }
}

extension SearchMovieViewController : UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let loading = LoadingIndicator(viewController: self)
        let searchedMovie = searchBar.text ?? ""
    
        MovieModel.shared.searchMoviesByName(movieName: searchedMovie, completion: { (movieInfoResponse) in
            DispatchQueue.main.async { [weak self] in
                loading.stopLoading()
                self?.bindData(movieInfoResponse)
            }
        })
        
    }
}

extension SearchMovieViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = searchedResult[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            vc.movieId = movie.id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            
            if let indexPaths = collectionViewMovieList.indexPathsForSelectedItems, indexPaths.count > 0 {
                let selectedIndexPath = indexPaths[0]
                let movie = searchedResult[selectedIndexPath.row]
                movieDetailsViewController.movieId = Int(movie.id ?? 0)
                
                self.navigationItem.title = movie.original_title
            }
            
        }
    }
}


extension SearchMovieViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}



