//
//  HomeViewControllerTests.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import XCTest
import RxSwift
@testable import MoviesTest

final class HomeViewControllerTests: XCTestCase {

    var viewController: HomeViewController!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        viewController = HomeViewController(viewModel: HomeViewModelMock.empty)
        _ = viewController.view
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewController = nil
    }
    
    func test_outletsAreSet() {
        let noUnasignedOutlets = [
            viewController.containerScrollView,
            viewController.mainContainer,
            viewController.searchResultsContainer,
            viewController.categoriesSegmentedControl,
            
            viewController.popularMoviesContainer,
            viewController.topRatedMoviesContainer,
            viewController.upcomingMoviesContainer,
        ].allSatisfy { $0 != nil }
        
        XCTAssert(noUnasignedOutlets)
    }

    func test_searchListResultIsSet() {
        XCTAssert(viewController.searchListViewController != nil)
    }
    
    func test_categoriesContainersAreSet() {
        let noUnasignedContainers = [
            viewController.popularMoviesViewController,
            viewController.topRatedMoviesViewController,
            viewController.upcomingMoviesViewController,
        ].allSatisfy { $0 != nil }
        
        XCTAssert(noUnasignedContainers)
    }
    
    func test_categoriesContainersAreListControllers() {
        let noUnasignedContainers = [
            viewController.popularMoviesViewController,
            viewController.topRatedMoviesViewController,
            viewController.upcomingMoviesViewController,
        ].allSatisfy { $0 is MoviesListViewController }
        
        XCTAssert(noUnasignedContainers)
    }
    
}
