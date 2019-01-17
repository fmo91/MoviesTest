//
//  CacheableMoviesSource.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 14/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift

struct CacheableMoviesSource: MoviesSource {
    private let localSource = LocalMoviesSource()
    private let remoteSource = RemoteMoviesSource()
    
    func searchMovies(text: String, criteria: SearchCriteriaItem) -> Observable<[Movie]> {
        switch criteria {
        case .all: return performTextSearch(for: text, criteria: criteria)
        default: return localSource.searchMovies(text: text, criteria: criteria)
        }
    }
    
    private func performTextSearch(for text: String, criteria: SearchCriteriaItem) -> Observable<[Movie]> {
        if InternetConnection.isWorking {
            return remoteSource.searchMovies(text: text, criteria: criteria)
                .do(onNext: { (movies: [Movie]) in
                    self.localSource.saveMovies(movies, forSearch: text)
                })
        } else {
            return localSource.searchMovies(text: text, criteria: criteria)
        }
    }
    
    func getMovies(category: Movie.Category, page: Int?) -> Observable<[Movie]> {
        if InternetConnection.isWorking {
            return remoteSource.getMovies(category: category, page: page)
                .do(onNext: { (movies: [Movie]) in
                    self.localSource.saveMovies(movies, page: page ?? 1, forCategory: category)
                })
        } else {
            return localSource.getMovies(category: category, page: page)
        }
    }
    
    func getVideos(movieId: Int) -> Observable<[Video]> {
        return remoteSource.getVideos(movieId: movieId)
    }
}
