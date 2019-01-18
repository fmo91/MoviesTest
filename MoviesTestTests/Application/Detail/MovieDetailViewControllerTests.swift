//
//  MovieDetailViewControllerTests.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import MoviesTest

final class MovieDetailViewControllerTests: XCTestCase {
    
    var viewController: MovieDetailViewController!
    var disposeBag: DisposeBag!
    var videosBehaviorSubject: BehaviorRelay<[String]>!

    override func setUp() {
        videosBehaviorSubject = BehaviorRelay<[String]>(value: [])
        let viewModel = MovieDetailViewModelMock(
            movieImagePath: "movieImagePath",
            movieTitle: "movieTitle",
            movieSubtitle: "movieSubtitle",
            infoSections: [
                MovieDetailInfoSection(title: "title1", contents: "contents1"),
                MovieDetailInfoSection(title: "title2", contents: "contents2"),
                MovieDetailInfoSection(title: "title3", contents: "contents3"),
            ],
            videos: videosBehaviorSubject
        )
        viewController = MovieDetailViewController(viewModel: viewModel, animator: nil)
        _ = viewController.view
    }

    override func tearDown() {
        viewController = nil
        disposeBag = nil
        videosBehaviorSubject = nil
    }

    func test_outletsAreSet() {
        let outletsAreSet = [
            viewController.tableView,
            viewController.topImageView,
            viewController.topImageViewHeightConstraint,
            viewController.topImageViewTopConstraint,
        ].allSatisfy { $0 != nil }
        
        XCTAssert(outletsAreSet, "@IBOutlet views should be set in the xib file.")
    }
    
    func test_imageParallaxEffectWorks() {
        viewController.tableView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
        XCTAssertEqual(
            viewController.topImageViewTopConstraint.constant,
            -60.0,
            "Image view top is incorrect."
        )
    }
    
    func test_imageBounceEffectWorks() {
        viewController.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
        XCTAssertEqual(
            viewController.topImageViewHeightConstraint.constant,
            350.0,
            "Image view height is incorrect."
        )
    }
    
    func test_videoChanges() {
        videosBehaviorSubject.accept(["", "", ""])
        let numberOfVideoRows = viewController.tableView(viewController.tableView, numberOfRowsInSection: MovieDetailSection.videos.rawValue)
        XCTAssertEqual(numberOfVideoRows, 3, "Number of video rows should be equal to the number of videos inserted in behavior subject (3)")
    }
    
}
