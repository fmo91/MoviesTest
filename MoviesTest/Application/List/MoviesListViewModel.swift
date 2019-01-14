//
//  MoviesListViewModel.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import RxSwift
import RxCocoa

final class MoviesListViewModel {
    
    // MARK: - Attributes -
    private let disposeBag = DisposeBag()
    internal let movies = BehaviorRelay<[MovieEntity]>(value: [])
    
    // MARK: - Init -
    init(moviesSource: Driver<[Movie]>) {
        moviesSource
            .map { movies in movies.toMovieEntities() }
            .drive(movies)
            .disposed(by: disposeBag)
    }
    
}

private extension Movie {
    func toMovieEntity() -> MovieEntity {
        return MovieEntity(
            movie       : self,
            imagePath   : self.posterPath,
            title       : self.title,
            overview    : self.overview
        )
    }
}

private extension Array where Element == Movie {
    func toMovieEntities() -> [MovieEntity] {
        return map { movie in movie.toMovieEntity() }
    }
}
