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
    
    private let category: Movie.Category
    private let rawMovies = BehaviorRelay<[Movie]>(value: [])
    private let source: MoviesSource
    
    internal let movies = BehaviorRelay<[MovieEntity]>(value: [])
    internal let didViewFinishLoading = PublishSubject<Void>()
    
    // MARK: - Init -
    init(source: MoviesSource, category: Movie.Category) {
        self.source = source
        self.category = category
        
        didViewFinishLoading.asObserver()
            .flatMap { [unowned self] in self.source.getMovies(category: category) }
            .bind(to: rawMovies)
            .disposed(by: disposeBag)
        
        rawMovies.asObservable()
            .map { movies in movies.toMovieEntities() }
            .bind(to: movies)
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
