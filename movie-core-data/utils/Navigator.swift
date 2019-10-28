//
//  Navigator.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/28/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Navigator {
    static func navigateToMovieDetailScreen(viewController : UIViewController, data : NSFetchRequestResult?) {
        if let data = data {
            if let movie = data as? MovieVO {
                if let movieDetailsViewController = viewController.storyboard?.instantiateViewController(withIdentifier: String(describing : MovieDetailsViewController.self)) as? MovieDetailsViewController {
                    movieDetailsViewController.movieId = Int(movie.id)
                    viewController.navigationItem.title = movie.original_title
                    viewController.navigationController?.pushViewController(movieDetailsViewController, animated: true)
                }
            }
            
            if let ratedMovie = data as? RatedMovieVO {
                let movie = MovieVO.getMovieById(movieId: Int(ratedMovie.movie_id))!
                if let movieDetailsViewController = viewController.storyboard?.instantiateViewController(withIdentifier: String(describing : MovieDetailsViewController.self)) as? MovieDetailsViewController {
                    movieDetailsViewController.movieId = Int(movie.id)
                    viewController.navigationItem.title = movie.original_title
                    viewController.navigationController?.pushViewController(movieDetailsViewController, animated: true)
                }
            }
            
            if let watchListMovie = data as? WatchListMovieVO {
                let movie = MovieVO.getMovieById(movieId: Int(watchListMovie.movie_id))!
                if let movieDetailsViewController = viewController.storyboard?.instantiateViewController(withIdentifier: String(describing : MovieDetailsViewController.self)) as? MovieDetailsViewController {
                    movieDetailsViewController.movieId = Int(movie.id)
                    viewController.navigationItem.title = movie.original_title
                    viewController.navigationController?.pushViewController(movieDetailsViewController, animated: true)
                }
            }
        }
    }
}
