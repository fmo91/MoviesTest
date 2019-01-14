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
        return remoteSource.searchMovies(text: text)
    }
    
    func getMovies(category: Movie.Category) -> Observable<[Movie]> {
        return remoteSource.getMovies(category: category)
    }
}
