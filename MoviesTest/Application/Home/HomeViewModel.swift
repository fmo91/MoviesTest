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
    func source(for category: Movie.Category) -> Driver<[Movie]>
    
    var selectedSearchCriteria: BehaviorRelay<SearchCriteriaItem?> { get }
    var didReachedEndForCategory: PublishSubject<Movie.Category> { get }
    var searchCriteriaItems: [SearchCriteriaItem] { get }
}

final class HomeViewModel: HomeViewModelType {
    
    // MARK: - Attributes -
    private let disposeBag = DisposeBag()
    private let source: MoviesSource
    
    let searchText = PublishSubject<String>()
    let searchResult: Driver<[SearchMovieEntity]>
    let didReachedEndForCategory = PublishSubject<Movie.Category>()
    let selectedSearchCriteria = BehaviorRelay<SearchCriteriaItem?>(value: nil)
    lazy var searchCriteriaItems: [SearchCriteriaItem] = SearchCriteriaItem.allCases
    
    private var nextPage = Movie.Category.allCases
        .reduce([Movie.Category: BehaviorRelay<Int>]()) { (dictionary, category) in
            var _dictionary = dictionary;
            _dictionary[category] = BehaviorRelay<Int>(value: 1)
            return _dictionary
        }
    
    // MARK: - Init -
    init(source: MoviesSource) {
        self.source = source
        
        let searchTextObservable = self.searchText.asObservable()
        let searchCriteriaObservable = self.selectedSearchCriteria.asObservable()
        
        searchResult = Observable<(String, SearchCriteriaItem?)>
            .combineLatest(
                searchTextObservable,
                searchCriteriaObservable,
                resultSelector: { text, criteria in (text, criteria) }
            )
            .throttle(0.5, scheduler: MainScheduler.instance)
            .flatMap { (bundle: (String, SearchCriteriaItem?)) -> Observable<[Movie]> in
                let (text, criteria) = bundle
                return source.searchMovies(
                    text: text,
                    criteria: criteria ?? .all
                )
            }
            .map { movies in movies.toSearchMovieEntities }
            .asDriver(onErrorJustReturn: [SearchMovieEntity]())
        
        didReachedEndForCategory.asObservable()
            .subscribe(onNext: { [unowned self] (category) in
                guard let nextPageForCategory = self.nextPage[category] else {
                    return
                }
                nextPageForCategory.accept(nextPageForCategory.value + 1)
            })
            .disposed(by: disposeBag)
        
        selectedSearchCriteria.accept(searchCriteriaItems.first)
    }
    
    func source(for category: Movie.Category) -> Driver<[Movie]> {
        guard let nextPageForCategory = nextPage[category] else {
            return .just([])
        }
        return nextPageForCategory.asObservable()
            .flatMapLatest { [unowned self] page in self.source.getMovies(category: category, page: page) }
            .concatenatedWithPrevious
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

private extension Observable where Element == [Movie] {
    var concatenatedWithPrevious: Observable<[Movie]> {
        return scan(into: [Movie](), accumulator: { (accumulatedMovies: inout [Movie], newMovies: [Movie]) in
            accumulatedMovies.append(contentsOf: newMovies)
        })
    }
}
