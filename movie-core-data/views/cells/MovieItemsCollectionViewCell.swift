//
//  MovieItemsCollectionViewCell.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/19/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class MovieItemsCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let movieListView : MovieListView = {
        let ui = MovieListView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        return ui
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(movieListView)
        movieListView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        movieListView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        movieListView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        movieListView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
    }
    
    func initState(fetchResultController : NSFetchedResultsController<NSFetchRequestResult>?, movieListTitle: String?) {
        self.movieListView.initState(fetchResultController: fetchResultController, movieListTitle: movieListTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
