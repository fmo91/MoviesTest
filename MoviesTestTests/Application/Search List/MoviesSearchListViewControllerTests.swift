//
//  MoviesSearchListViewControllerTests.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import XCTest
import RxSwift
@testable import MoviesTest

final class MoviesSearchListViewControllerTests: XCTestCase {
    
    var viewController: MoviesSearchListViewController!
    var disposeBag: DisposeBag!

    override func setUp() {
        viewController = MoviesSearchListViewController(criteriaItems: SearchCriteriaItem.allCases)
        disposeBag = DisposeBag()
        _ = viewController.view
    }

    override func tearDown() {
        viewController = nil
    }

    func test_viewControllerShowsContents() {
        let numberOfMovies = 5
        let sampleMovies = Array<SearchMovieEntity>.init(repeating: .empty, count: numberOfMovies)
        viewController.movies.accept(sampleMovies)
        XCTAssert(viewController.tableView.numberOfRows(inSection: 0) == numberOfMovies)
    }
    
    func test_viewControllerNotifySelection() {
        let firstMovie = SearchMovieEntity(movie: nil, imagePath: "", title: "FIRST MOVIE", subtitle: "")
        let sampleMovies: [SearchMovieEntity] = [firstMovie, .empty, .empty]
        let movieSeletionExpectation = expectation(description: "movie_selection")
        viewController.movies.accept(sampleMovies)
        viewController.didSelectMovie.asObservable()
            .subscribe(onNext: { (movieEntity) in
                XCTAssert(movieEntity.title == firstMovie.title)
                movieSeletionExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        wait(for: [movieSeletionExpectation], timeout: 3.0)
    }

}
