//
//  GenreListViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/20/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class GenreListViewController: UIViewController {

    @IBOutlet weak var tableViewGenreList : UITableView!
    
    var genreFetchResultController : NSFetchedResultsController<MovieGenreVO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewGenreList.dataSource = self
        tableViewGenreList.backgroundColor = Theme.background
        
     
        initView()
    }
    
    fileprivate func initView() {
        let fetchRequest = MovieGenreVO.getFetchRequest()
        genreFetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "genre_list")
        
        do {
            try genreFetchResultController.performFetch()
        } catch {
            Dialog.showAlert(viewController: self, title: "Error", message: "failed to load genres \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieListByGenreViewController = segue.destination as? MovieListByGenreViewController {
            if let indexPath = tableViewGenreList.indexPathForSelectedRow {
                let genreVO = genreFetchResultController.object(at: indexPath)
                movieListByGenreViewController.movieGenreVO = genreVO
                
                self.navigationItem.title = genreVO.name
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Genres"
    }

}

extension GenreListViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return genreFetchResultController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreFetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieGenreVO = genreFetchResultController.object(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreListTableViewCell.identifier, for: indexPath) as? GenreListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = Theme.background
        cell.labelGenreTitle.text = movieGenreVO.name
        cell.labelGenreTitle.textColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
}

