//
//  HomeViewModel.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import RxSwift
import RxCocoa

protocol HomeViewModelType {
    var searchText: PublishSubject<String> { get }
    
    var searchResult: Driver<[SearchMovieEntity]> { get }
    var popularMovies: Driver<[Movie]> { get }
    var topRatedMovies: Driver<[Movie]> { get }
    var upcomingMovies: Driver<[Movie]> { get }
    
    var didReachedEndForCategory: PublishSubject<Movie.Category> { get }
}

final class HomeViewModel: HomeViewModelType {
    
    // MARK: - Attributes -
    private let disposeBag = DisposeBag()
    private let source: MoviesSource
    
    let searchText = PublishSubject<String>()
    
    let searchResult: Driver<[SearchMovieEntity]>
    let popularMovies: Driver<[Movie]>
    let topRatedMovies: Driver<[Movie]>
    let upcomingMovies: Driver<[Movie]>
    
    let didReachedEndForCategory = PublishSubject<Movie.Category>()
    
    private var popularMoviesNextPage = BehaviorRelay<Int>(value: 1)
    private var topRatedMoviesNextPage = BehaviorRelay<Int>(value: 1)
    private var upcomingMoviesNextPage = BehaviorRelay<Int>(value: 1)
    
    // MARK: - Init -
    init(source: MoviesSource) {
        self.source = source
        
        searchResult = searchText.asObservable()
            .flatMap { text in source.searchMovies(text: text) }
            .map { movies in movies.toSearchMovieEntities }
            .asDriver(onErrorJustReturn: [])
        
        popularMovies = popularMoviesNextPage.asObservable()
            .flatMapLatest { page in source.getMovies(category: .popular, page: page) }
            .concatenatedWithPrevious
            .asDriver(onErrorJustReturn: [])
        
        topRatedMovies = topRatedMoviesNextPage.asObservable()
            .flatMapLatest { page in source.getMovies(category: .topRated, page: page) }
            .concatenatedWithPrevious
            .asDriver(onErrorJustReturn: [])
        
        upcomingMovies = upcomingMoviesNextPage.asObservable()
            .flatMapLatest { page in source.getMovies(category: .upcoming, page: page) }
            .concatenatedWithPrevious
            .asDriver(onErrorJustReturn: [])
        
        didReachedEndForCategory.asObservable()
            .subscribe(onNext: { [unowned self] (category) in
                switch category {
                case .popular: self.popularMoviesNextPage.accept(self.popularMoviesNextPage.value + 1)
                case .topRated: self.topRatedMoviesNextPage.accept(self.topRatedMoviesNextPage.value + 1)
                case .upcoming: self.upcomingMoviesNextPage.accept(self.upcomingMoviesNextPage.value + 1)
                }
            })
            .disposed(by: disposeBag)
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

private extension Observable where Element == [Movie] {
    var concatenatedWithPrevious: Observable<[Movie]> {
        return scan(into: [Movie](), accumulator: { (accumulatedMovies: inout [Movie], newMovies: [Movie]) in
            accumulatedMovies.append(contentsOf: newMovies)
        })
    }
}
