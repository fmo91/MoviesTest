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
    
    func searchMovies(text: String) -> Observable<[Movie]> {
        return localSource.searchMovies(text: text)
            .concat(
                remoteSource.searchMovies(text: text)
                    .do(onNext: { (movies: [Movie]) in
                        self.localSource.saveMovies(movies, forSearch: text)
                    })
            )
    }
    
    func getMovies(category: Movie.Category) -> Observable<[Movie]> {
        return localSource.getMovies(category: category)
            .concat(
                remoteSource.getMovies(category: category)
                    .do(onNext: { (movies: [Movie]) in
                        self.localSource.saveMovies(movies, forCategory: category)
                    })
            )
    }
}
