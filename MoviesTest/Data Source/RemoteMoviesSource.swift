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
    func searchMovies(text: String) -> Single<[Movie]> {
        if text.isEmpty {
            return .just([])
        }
        
        return SearchMoviesRequest(keyword: text).rx_dispatch()
            .map { $0.results }
    }
    func getMovies(category: Movie.Category) -> Single<[Movie]> {
        return GetMoviesRequest(category: category).rx_dispatch()
            .map { $0.results }
    }
}
