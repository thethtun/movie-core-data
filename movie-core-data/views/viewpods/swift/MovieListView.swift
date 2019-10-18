//
//  MovieListView.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/12/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable
class MovieListView: UIView {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var collectionViewMovieList : UICollectionView!
    @IBOutlet weak var labelMovieListTitle : UILabel!
    
    private let NIB_FILE_NAME = "MovieListView"
    
    var movieListTitle : String? {
        didSet {
            if let title = movieListTitle {
                labelMovieListTitle.text = title
            }
        }
    }
    
    var fetchRequestController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            
            if let controller = fetchRequestController {
                controller.delegate = self
                do{
                    try controller.performFetch()
                    
                } catch {
                    print("\(error.localizedDescription)")
                }
            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commiteInit()
        
        initView()
    }
    
    
    private func commiteInit() {
        let bundle = Bundle(for: MovieListView.self)
        bundle.loadNibNamed(NIB_FILE_NAME, owner: self, options: nil)
        self.addSubview(containerView)
        addConstraintToParentView()
        
    }
    
    private func initView() {
        collectionViewMovieList.dataSource = self
        collectionViewMovieList.delegate = self
        collectionViewMovieList.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        
    }
    
    private func addConstraintToParentView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}


extension MovieListView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchRequestController?.sections?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchRequestController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let fetchRequestResult = fetchRequestController?.object(at: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let movie = fetchRequestResult as? MovieVO  {
            cell.data = movie
        }
        
    
        return cell
    }
}

extension MovieListView: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionViewMovieList.reloadData()
    }
}


extension MovieListView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}


