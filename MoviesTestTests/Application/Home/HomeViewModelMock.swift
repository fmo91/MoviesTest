//
//  HomeViewModelMock.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import MoviesTest

final class HomeViewModelMock: HomeViewModelType {
    
    let searchText = PublishSubject<String>()
    
    let searchResult: Driver<[SearchMovieEntity]>
    let popularMovies: Driver<[Movie]>
    let topRatedMovies: Driver<[Movie]>
    let upcomingMovies: Driver<[Movie]>
    
    let didReachedEndForCategory = PublishSubject<Movie.Category>()
    
    static var empty: HomeViewModelMock {
        return HomeViewModelMock(
            searchResult: .just([]),
            popularMovies: .just([]),
            topRatedMovies: .just([]),
            upcomingMovies: .just([])
        )
    }
    
    init(
        searchResult: Driver<[SearchMovieEntity]>,
        popularMovies: Driver<[Movie]>,
        topRatedMovies: Driver<[Movie]>,
        upcomingMovies: Driver<[Movie]>
    ) {
        self.searchResult = searchResult
        self.popularMovies = popularMovies
        self.topRatedMovies = topRatedMovies
        self.upcomingMovies = upcomingMovies
    }
    
}
