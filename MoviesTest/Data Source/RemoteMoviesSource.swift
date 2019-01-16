//
//  RemoteMoviesSource.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift

struct RemoteMoviesSource: MoviesSource {
    func searchMovies(text: String) -> Observable<[Movie]> {
        if text.isEmpty {
            return .just([])
        }
        
        return SearchMoviesRequest(keyword: text).rx_dispatch()
            .asObservable()
            .map { $0.results }
    }
    func getMovies(category: Movie.Category, page: Int?) -> Observable<[Movie]> {
        return GetMoviesRequest(fetchFilter: category, page: page).rx_dispatch()
            .asObservable()
            .map { $0.results }
    }
    func getVideos(movieId: Int) -> Observable<[Video]> {
        return GetVideosRequest(movieId: movieId).rx_dispatch()
            .asObservable()
            .map { $0.results }
    }
}
