//
//  fetchMovie.swift
//  movie-core-data
//
//  Created by Thet Htun on 4/17/20.
//  Copyright © 2020 padc. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk
import CoreData


func fetchMovieDetailsThunk(_ movieId : Int) -> Thunk<AppState> {
    return Thunk<AppState> { (dispatch, getState) in
        
        dispatch(ShowLoading())
        
        MovieModel.shared.fetchMovieDetails(movieId: movieId, completion: { movieDetails in
            
            let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
            let predicate = NSPredicate(format: "id == %d", movieId)
            fetchRequest.predicate = predicate
            
            var moviePlaceholder : MovieVO? = nil
            if let movies = try? CoreDataStack.shared.viewContext.fetch(fetchRequest), !movies.isEmpty {
                MovieInfoResponse.updateMovieEntity(existingData: movies[0], newData: movieDetails, context: CoreDataStack.shared.viewContext)
                moviePlaceholder = movies[0]
            } else {
                let movieVO = MovieInfoResponse.convertToMovieVO(data: movieDetails, context: CoreDataStack.shared.viewContext)
                moviePlaceholder = movieVO
            }
            
            //Dispatch & Update State
            dispatch(FetchMovieDetailsSuccess(data : moviePlaceholder))
        }) { (err) in
            dispatch(NetworkFetchFailed(err: err))
        }
    }
}

let fetchMoviesFromNetwork = Thunk<AppState> { (dispatch, getState) in
    var movieInfoResponses = [MovieInfoResponse]()
    
    MovieVO.deleteAllMovies()
    
    MovieModel.shared.fetchTopRatedMovies(pageId: 1) { data in
        data.forEach({ (movieInfo) in
            var data = movieInfo
            data.movieTag = MovieTag.TOP_RATED
            movieInfoResponses.append(data)
        })
        
        MovieModel.shared.fetchPopularMovies(pageId: 1) { data in
            data.forEach({ (movieInfo) in
                var data = movieInfo
                data.movieTag = MovieTag.POPULAR
                movieInfoResponses.append(data)
            })
            
            MovieModel.shared.fetchUpcomingMovies(pageId: 1) { data in
                data.forEach({ (movieInfo) in
                    var data = movieInfo
                    data.movieTag = MovieTag.UPCOMING
                    movieInfoResponses.append(data)
                })
                
                MovieModel.shared.fetchNowPlaying(pageId: 1) {  data in
                    data.forEach({ (movieInfo) in
                        var data = movieInfo
                        data.movieTag = MovieTag.NOW_PLAYING
                        movieInfoResponses.append(data)
                    })
                    
                    DispatchQueue.main.async {
                        if movieInfoResponses.isEmpty {
                            dispatch(FetchMoviesFailed(err: "Failed to fetch movies!"))
                        }
                        
                        movieInfoResponses.forEach({ (movieInfoRes) in
                            MovieInfoResponse.saveMovieEntity(data: movieInfoRes, context: CoreDataStack.shared.viewContext)
                        })

                        dispatch(FetchMoviesSuccess())
                    }
                }
            }
        }
    }
}


let startMovieListFetchRequest = Thunk<AppState> { (dispatch, getState) in
    
    let fetchRequest : NSFetchRequest<MovieVO> = MovieVO.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    do {
        let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
        if data.isEmpty {
            dispatch(fetchMoviesFromNetwork)
        }
        
    } catch {
        print("\(error.localizedDescription)")
    }
    
}

let startGenreListFetchRequest = Thunk<AppState> { (dispatch, getState) in
    let fetchRequest: NSFetchRequest<MovieGenreVO> = MovieGenreVO.fetchRequest()
    
    do{
        let genres = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
        if genres.isEmpty{
            dispatch(fetchMovieGenresFromNetwork)
        }
        
    } catch {
        print("TAG: \(error.localizedDescription)")
    }
}

