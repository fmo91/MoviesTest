//
//  MoviesListViewControllerTests.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import MoviesTest

final class MoviesListViewControllerTests: XCTestCase {
    
    var viewController: MoviesListViewController!
    var movies: BehaviorRelay<[MovieEntity]>!

    override func setUp() {
        movies = .init(value: [])
        let viewModel = MoviesListViewModelMock(movies: movies)
        viewController = MoviesListViewController(viewModel: viewModel)
        _ = viewController.view
    }

    override func tearDown() {
        viewController = nil
        movies = nil
    }
    
    func test_numberOfMovies() {
        let movieEntities = [
            MovieEntity(movie: nil, imagePath: nil, title: "tt", overview: "ov"),
            MovieEntity(movie: nil, imagePath: nil, title: "tt", overview: "ov"),
            MovieEntity(movie: nil, imagePath: nil, title: "tt", overview: "ov"),
            MovieEntity(movie: nil, imagePath: nil, title: "tt", overview: "ov"),
        ]
        movies.accept(movieEntities)
        let numberOfItems = viewController.collectionView(viewController.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(numberOfItems, movieEntities.count, "Collection view is not displaying all movies")
    }

}
