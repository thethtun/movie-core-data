//
//  MovieDetailsViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/18/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData
import CoreImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var buttonDismissContainer : UIView!
    @IBOutlet weak var imageViewMoviePoster : UIImageView!
    @IBOutlet weak var imageViewMovieBackDrop : UIImageView!
    @IBOutlet weak var labelMovieDescription : UILabel!
    @IBOutlet weak var labelMovieDescriptionHeight : NSLayoutConstraint!
    @IBOutlet weak var labelMovieReleaseYear : UILabel!
    @IBOutlet weak var labelMovieTargetAudience : UILabel!
    @IBOutlet weak var labelMovieDuration : UILabel!
    @IBOutlet weak var collectionViewSimilarMovies : UICollectionView!
    @IBOutlet weak var collectionViewSimilarMoviesHeight : NSLayoutConstraint!
    @IBOutlet weak var buttonAddToWatchList : UIButton!
    @IBOutlet weak var buttonRateMovie : UIButton!
    @IBOutlet weak var labelRateMovie : UILabel!
    @IBOutlet weak var labelAddToWatchList : UILabel!
    
    static var identifier = "MovieDetailsViewController"
    var movieId : Int = 0
    var bookmarkButton = UIButton(type: .custom)
    var isBookmarked = false
    
    private var similarMovies = [MovieInfoResponse]()
    private var movieTrailerId = ""
    private var isMovieRated : Bool? {
        didSet {
            if let isMovieRated = isMovieRated, isMovieRated  {
                labelRateMovie.text = "Un-Rate"
                labelRateMovie.textColor = UIColor.red
                buttonRateMovie.setImage(#imageLiteral(resourceName: "icons8-thumb_up_red"), for: .normal)
            } else {
                labelRateMovie.text = "Rate"
                labelRateMovie.textColor = UIColor.lightGray
                buttonRateMovie.setImage(#imageLiteral(resourceName: "icons8-thumb_up"), for: .normal)
            }
        }
    }
    private var isMovieInWatchList : Bool? {
        didSet {
            if let isMovieInWatchList = isMovieInWatchList, isMovieInWatchList {
                labelAddToWatchList.textColor = UIColor.red
                buttonAddToWatchList.setImage(#imageLiteral(resourceName: "icons8-checkmark_filled"), for: .normal)
            } else {
                labelAddToWatchList.textColor = UIColor.lightGray
                buttonAddToWatchList.setImage(#imageLiteral(resourceName: "icons8-plus"), for: .normal)
            }
        }
    }
    private let sessionId = UserDefaultsManager.getSessionId()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            if let data = MovieVO.getMovieById(movieId: movieId) {
                self.bindData(data: data)
            }
            return
        }
        
        fetchMovieDetails()
        
        fetchSimilarMovies()
        
        isMovieRated = RatedMovieVO.isMovieRated(movieId: movieId, context: CoreDataStack.shared.viewContext)
        isMovieInWatchList = WatchListMovieVO.isMoviewatchList(movieId: movieId, context: CoreDataStack.shared.viewContext)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    fileprivate func initView() {
        navigationItem.hidesBackButton = true
        buttonDismissContainer.layer.cornerRadius = buttonDismissContainer.frame.size.width / 2
        
        collectionViewSimilarMovies.delegate = self
        collectionViewSimilarMovies.dataSource = self
        collectionViewSimilarMovies.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        collectionViewSimilarMoviesHeight.constant = 0
    }
    
    fileprivate func fetchMovieDetails() {
        let loadingIndicator = LoadingIndicator(viewController: self)
        MovieModel.shared.fetchMovieDetails(movieId: movieId) { movieDetails in
            
            let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
            let predicate = NSPredicate(format: "id == %d", self.movieId)
            fetchRequest.predicate = predicate
            if let movies = try? CoreDataStack.shared.viewContext.fetch(fetchRequest), !movies.isEmpty {
                MovieInfoResponse.updateMovieEntity(existingData: movies[0], newData: movieDetails, context: CoreDataStack.shared.viewContext)
                DispatchQueue.main.async { [weak self] in
                    loadingIndicator.stopLoading()
                    self?.bindData(data: movies[0])
                }
            } else {
                let movieVO = MovieInfoResponse.convertToMovieVO(data: movieDetails, context: CoreDataStack.shared.viewContext)
                
                DispatchQueue.main.async { [weak self] in
                    loadingIndicator.stopLoading()
                    self?.bindData(data: movieVO)
                }
            }
            
        }
    }
 
    fileprivate func fetchSimilarMovies() {
        
        MovieModel.shared.fetchSimilarMovies(movieId: movieId) { [weak self] similarMovies in
            DispatchQueue.main.async {
                self?.similarMovies = similarMovies
                self?.collectionViewSimilarMovies.reloadData()
            }
        }
    }
    
    fileprivate func fetchRelatedVideoID(_ completion : @escaping () -> Void) {
        let loader = LoadingIndicator(viewController: self)
        MovieModel.shared.fetchMovieVideo(movieId: movieId) { movieVideoResponse in
            DispatchQueue.main.async { [weak self] in
                loader.stopLoading()
                if let response = movieVideoResponse {
                    if response.results.count > 0 {
                        self?.movieTrailerId = response.results[0].key ?? ""
                        completion()
                    } else {
                        Dialog.showAlert(viewController: self!, title: "Uh-oh", message: "No Trailer for this movie :(")
                    }
                }
            }
        }
    }
   
    
    @IBAction func onClickViewTrailer(_ sender : Any) {
        
        fetchRelatedVideoID { [weak self] in
            let viewcontroller = self?.storyboard?.instantiateViewController(withIdentifier: "MovieTrailerViewController") as? MovieTrailerViewController
            viewcontroller?.videoId = self?.movieTrailerId
            guard let vc = viewcontroller else {
                return
            }
            self?.navigationController?.isNavigationBarHidden = false
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    fileprivate func bindData(data : MovieVO) {
        imageViewMoviePoster.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), completed: nil)
        imageViewMovieBackDrop.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), completed: nil)
        imageViewMovieBackDrop.blur()
        
        if let release_date = data.release_date {
            let results = release_date.split(separator: "-")
            if results.count > 0 {
                labelMovieReleaseYear.text = String(results[0])
            }
            
        }
        
        let movie_overview = data.overview ?? ""
        labelMovieDescription.text = movie_overview
        let calculatedMovieOverviewHeight = labelMovieDescription.getHeight(for: movie_overview, font: UIFont.systemFont(ofSize: 15), width: self.view.frame.width - 100)
        labelMovieDescriptionHeight.constant = calculatedMovieOverviewHeight
        
        labelMovieDuration.text = "\(data.runtime) mins"
        labelMovieTargetAudience.text = data.adult ? "18+" : "Not Rated"
 
    }
    
    
    
    @IBAction func onClickDismiss(_ sender : Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAddToWatchList(_ sender : Any) {
        let loader = LoadingIndicator(viewController: self)
        guard let isMovieInWatchList = isMovieInWatchList else {
            Dialog.showAlert(viewController: self, title: "Error", message: "Dismiss current view and try again. (Dev Debug: isMovieInWatchList is null.)")
            return
        }
        if isMovieInWatchList {
            UserModel.shared.removeFromWatchList(sessionId: sessionId, movieId: movieId) { (data) in
                DispatchQueue.main.async {
                    WatchListMovieVO.delete(movieId: self.movieId, context: CoreDataStack.shared.viewContext)
                    loader.stopLoading()
                    self.isMovieInWatchList = false
                }
            }
        } else {
            UserModel.shared.addToWatchList(sessionId: sessionId, movieId: movieId) { (data) in
                MovieModel.shared.fetchMovieDetails(movieId: self.movieId, completion: { (data) in
                    DispatchQueue.main.async {
                        MovieInfoResponse.saveMovieEntity(data: data, context: CoreDataStack.shared.viewContext)
                        WatchListMovieVO.save(movieId: self.movieId, context: CoreDataStack.shared.viewContext)
                        loader.stopLoading()
                        self.isMovieInWatchList = true
                    }
                })
            }
        }
        
    }
    
    @IBAction func onClickRateMovie(_ sender : Any) {
        let loader = LoadingIndicator(viewController: self)
        guard let isMovieRated = isMovieRated else {
            Dialog.showAlert(viewController: self, title: "Error", message: "Dismiss current view and try again. (Dev Debug: isMovieRated is null.)")
            return
        }
        if isMovieRated {
            UserModel.shared.deleteRating(movieId: self.movieId) { (data) in
                DispatchQueue.main.async {
                    RatedMovieVO.delete(movieId: self.movieId, context: CoreDataStack.shared.viewContext)
                    loader.stopLoading()
                    self.isMovieRated = false
                }
            }
        } else {
            UserModel.shared.rateMovie(movieId: self.movieId) { (data) in
                MovieModel.shared.fetchMovieDetails(movieId: self.movieId, completion: { (data) in
                    DispatchQueue.main.async {
                        MovieInfoResponse.saveMovieEntity(data: data, context: CoreDataStack.shared.viewContext)
                        RatedMovieVO.save(movieId: self.movieId, context: CoreDataStack.shared.viewContext)
                        loader.stopLoading()
                        self.isMovieRated = true
                    }
                })
            }
        }
    }
    
}

extension MovieDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let width = (collectionView.bounds.width / 3) - 10;
        let heightForSingleRow = width * 1.45
        var totalCount = similarMovies.count
        repeat {
            collectionViewSimilarMoviesHeight.constant += heightForSingleRow
            totalCount = totalCount - 3
        } while totalCount > 0
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = similarMovies[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.data = MovieInfoResponse.convertToMovieVO(data: movie, context: CoreDataStack.shared.viewContext)
        
        return cell
    }
}

extension MovieDetailsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = similarMovies[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            vc.movieId = movie.id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension MovieDetailsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}


extension UILabel {
    func getHeight(for string: String, font: UIFont, width: CGFloat) -> CGFloat {
        let textStorage = NSTextStorage(string: string)
        let textContainter = NSTextContainer(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainter)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, textStorage.length))
        textContainter.lineFragmentPadding = 0.0
        layoutManager.glyphRange(for: textContainter)
        return layoutManager.usedRect(for: textContainter).size.height
    }
}
