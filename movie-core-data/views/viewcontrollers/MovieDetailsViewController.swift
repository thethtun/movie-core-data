//
//  MovieDetailsViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/18/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import RealmSwift

class MovieDetailsViewController: UIViewController {

    let scrollViewPrimary : UIScrollView = {
        let ui = UIScrollView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        return ui
    }()
    
    let stackViewTemp : UIStackView = {
        let ui = UIStackView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.axis = .vertical
        ui.spacing = 5
        return ui
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let ui = UIActivityIndicatorView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.color = UIColor.red
        ui.startAnimating()
        return ui
    }()
    
    var movieId : Int = 0
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        
        ///Load persistent data
        if let data = MovieVO.getMovieById(movieId: movieId, realm: realm) {
            self.bindData(data: data)
        }
    
    }

    
    fileprivate func initView() {
        self.view.addSubview(scrollViewPrimary)
        scrollViewPrimary.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        scrollViewPrimary.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        scrollViewPrimary.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollViewPrimary.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        scrollViewPrimary.backgroundColor = Theme.background
        
        scrollViewPrimary.addSubview(stackViewTemp)
        stackViewTemp.leadingAnchor.constraint(equalTo: self.scrollViewPrimary.leadingAnchor, constant: 20).isActive = true
        stackViewTemp.trailingAnchor.constraint(equalTo: self.scrollViewPrimary.trailingAnchor, constant: -20).isActive = true
        stackViewTemp.topAnchor.constraint(equalTo: self.scrollViewPrimary.topAnchor, constant: 20).isActive = true
        stackViewTemp.bottomAnchor.constraint(equalTo: self.scrollViewPrimary.bottomAnchor, constant: 20).isActive = true
        stackViewTemp.centerXAnchor.constraint(equalTo: self.scrollViewPrimary.centerXAnchor).isActive = true
        
        scrollViewPrimary.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: scrollViewPrimary.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: scrollViewPrimary.centerYAnchor, constant: -100).isActive = true
        activityIndicator.startAnimating()
        

    }
    
    @objc private func onClickBookmark(_ sender : UIBarButtonItem) {
        ///bookmarked
        if sender.image == #imageLiteral(resourceName: "icons8-bookmark_ribbon_filled_red") {
            BookmarkVO.deleteMovieBookmark(movieId: movieId, realm: realm)
            sender.image = #imageLiteral(resourceName: "icons8-bookmark_ribbon_not_fillled")
            sender.tintColor = UIColor.white
        } else { ///not yet bookmarked
            BookmarkVO.saveMovieBookmark(movieId: movieId, realm: realm)
            sender.image = #imageLiteral(resourceName: "icons8-bookmark_ribbon_filled_red")
            sender.tintColor = UIColor.red
        }
    }
    
    fileprivate func fetchMovieDetails(movieId : Int) {
        
        MovieModel.shared.fetchMovieDetails(movieId: movieId) { [weak self] movieDetails in
            
            DispatchQueue.main.async {
                self?.bindData(data: MovieInfoResponse.convertToMovieVO(data: movieDetails, realm: self!.realm))
            }
        }
        
    }
    
    
    fileprivate func bindData(data : MovieVO) {
        activityIndicator.stopAnimating()
        
        ///setting movie overview
        let overviewTitle = WidgetGenerator.getUILabelTitle("Overview")
        stackViewTemp.addArrangedSubview(overviewTitle)
        let movieOverview = data.overview ?? "No overview"
        stackViewTemp.addArrangedSubview(WidgetGenerator.getUILabelMovieInfo(movieOverview))
        addTempSpacing()
        
        ///setting release data
        let releaseTitle = WidgetGenerator.getUILabelTitle("Release Date")
        stackViewTemp.addArrangedSubview(releaseTitle)
        let releasedDate = data.release_date ?? "No release date"
        stackViewTemp.addArrangedSubview(WidgetGenerator.getUILabelMovieInfo(releasedDate))
        addTempSpacing()
        
        ///setting genres view
        let genreTitle = WidgetGenerator.getUILabelTitle("Genres")
        stackViewTemp.addArrangedSubview(genreTitle)
        if data.genres.count > 0 {
            data.genres.forEach{ genre in
                stackViewTemp.addArrangedSubview(WidgetGenerator.getUILabelMovieInfo(genre.name))
            }
        }
        addTempSpacing()
        
        ///setting rating view
        let ratinTitle = WidgetGenerator.getUILabelTitle("Rating")
        stackViewTemp.addArrangedSubview(ratinTitle)
        stackViewTemp.addArrangedSubview(WidgetGenerator.getUILabelMovieInfo("\(data.vote_average)"))
        
        ///setting bookmark
        let bookmarkItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-bookmark_ribbon_not_fillled"), style: .plain, target: self, action: #selector(onClickBookmark(_:)))
        bookmarkItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: -10)
        if let _ = realm.object(ofType: BookmarkVO.self, forPrimaryKey: data.id) {
            bookmarkItem.image = #imageLiteral(resourceName: "icons8-bookmark_ribbon_filled_red")
            bookmarkItem.tintColor = UIColor.red
        } else {
            bookmarkItem.image = #imageLiteral(resourceName: "icons8-bookmark_ribbon_not_fillled")
            bookmarkItem.tintColor = UIColor.white
        }
        
        navigationItem.rightBarButtonItem = bookmarkItem
        
    }
    
    func addTempSpacing() {
        stackViewTemp.addArrangedSubview(WidgetGenerator.getUILabelMovieInfo(" ")) //Add some spacing
    }
    
}
