//
//  HomeViewModel.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    
    // MARK: - Attributes -
    private let source: MoviesSource
    
    let searchText = PublishSubject<String>()
    
    let searchResult: Driver<[SearchMovieEntity]>
    
    // MARK: - Init -
    init(source: MoviesSource) {
        self.source = source
        
        searchResult = searchText.asObservable()
            .flatMap { text in source.searchMovies(text: text) }
            .map { movies in movies.toSearchMovieEntities }
            .asDriver(onErrorJustReturn: [])
    }
    
}

private extension Array where Element == Movie {
    var toSearchMovieEntities: [SearchMovieEntity] {
        return self.map {
            return SearchMovieEntity(
                movie       : $0,
                imagePath   : $0.posterPath ?? "",
                title       : $0.title,
                subtitle    : $0.overview
            )
        }
    }
}
