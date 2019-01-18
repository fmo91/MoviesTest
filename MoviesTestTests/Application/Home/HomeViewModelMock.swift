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
    let searchText: PublishSubject<String> = .init()
    let selectedSearchCriteria: BehaviorRelay<SearchCriteriaItem?> = .init(value: nil)
    let didReachedEndForCategory: PublishSubject<Movie.Category> = .init()
    
    let searchResult: Driver<[SearchMovieEntity]>
    let searchCriteriaItems: [SearchCriteriaItem]
    
    private let _source: (Movie.Category) -> Driver<[Movie]>
    func source(for category: Movie.Category) -> Driver<Array<Movie>> {
        return _source(category)
    }
    
    init(
        searchResult: Driver<[SearchMovieEntity]>,
        searchCriteriaItems: [SearchCriteriaItem],
        source: @escaping (Movie.Category) -> Driver<[Movie]>
    ) {
        self.searchResult = searchResult
        self.searchCriteriaItems = searchCriteriaItems
        self._source = source
    }
}
