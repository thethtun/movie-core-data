//
//  MovieDetailsViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/18/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit

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
    
    var data : MovieVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        MovieModel.shared.fetchMovieDetails(movieId: data?.id ?? 0)
        

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
        
        let overviewTitle = WidgetGenerator.getUILabelTitle("Overview")
        stackViewTemp.addArrangedSubview(overviewTitle)
        let movieOverview = data?.overview ?? "No overview"
        stackViewTemp.addArrangedSubview(WidgetGenerator.getUILabelMovieInfo(movieOverview))
        
        stackViewTemp.addArrangedSubview(WidgetGenerator.getUILabelMovieInfo(" ")) //Add some spacing
        
        let releaseTitle = WidgetGenerator.getUILabelTitle("Release Date")
        stackViewTemp.addArrangedSubview(releaseTitle)
        let releasedDate = data?.release_date ?? "No release date"
        stackViewTemp.addArrangedSubview(WidgetGenerator.getUILabelMovieInfo(releasedDate))
        
    
    }
    
}