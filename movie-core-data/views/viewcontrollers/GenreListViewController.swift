//
//  GenreListViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/20/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import RealmSwift

class GenreListViewController: UIViewController {

    @IBOutlet weak var tableViewGenreList : UITableView!
    
    let realm = try! Realm()
    
    var movieGenres : Results<MovieGenreVO>?
    
    var movieGenresNotiToken : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewGenreList.dataSource = self
        tableViewGenreList.backgroundColor = Theme.background
        
     
        initView()
    }
    
    fileprivate func initView() {
        
        //TODO: Implement Realm GenreVO List Observer
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieListByGenreViewController = segue.destination as? MovieListByGenreViewController {
            if let indexPath = tableViewGenreList.indexPathForSelectedRow {
                let genreVO = movieGenres?[indexPath.row]
                movieListByGenreViewController.movieGenreVO = genreVO
                
                self.navigationItem.title = genreVO?.name ?? ""
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Genres"
    }
    
    deinit {
        movieGenresNotiToken?.invalidate()
    }

}

extension GenreListViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieGenres?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieGenreVO = movieGenres?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreListTableViewCell.identifier, for: indexPath) as? GenreListTableViewCell else {
            return UITableViewCell()
        }

        cell.backgroundColor = Theme.background
        cell.labelGenreTitle.text = movieGenreVO?.name ?? "undefined"
        cell.labelGenreTitle.textColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
}

