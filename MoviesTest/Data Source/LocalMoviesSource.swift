//
//  LocalMoviesSource.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift

struct LocalMoviesSource: MoviesSource {
    func searchMovies(text: String) -> Observable<[Movie]> {
        return .just([])
    }
    
    func getMovies(category: Movie.Category) -> Observable<[Movie]> {
        return .just([])
    }
    
    func saveMovies(_ movies: [Movie], forSearch text: String) {
        print("LOCAL -> Saving \(movies.count) movies for search \(text)")
    }
    
    func saveMovies(_ movies: [Movie], forCategory category: Movie.Category) {
        print("LOCAL -> Saving \(movies.count) movies for category \(category.displayableName)")
    }
}
