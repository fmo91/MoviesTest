//
//  MovieDetailViewModelTests.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import XCTest
import RxSwift
@testable import MoviesTest

final class MovieDetailViewModelTests: XCTestCase {

    var viewModel: MovieDetailViewModel!
    var disposeBag: DisposeBag!
    var source: MockMoviesSource!
    
    override func setUp() {
        let movie = Movie(
            posterPath: "/Poster",
            adult: false,
            overview: "Overview",
            releaseDate: Date(),
            genreIds: [],
            id: 10,
            originalTitle: "original title",
            originalLanguage: "lang",
            title: "title",
            backdropPath: "backdrop",
            popularity: 0.3,
            video: true,
            voteAverage: 0.8
        )
        
        disposeBag = DisposeBag()
        source = MockMoviesSource.init()
        source.getVideosResult = Result<[Video]>.success([
            Video(key: "sample_key_1"),
            Video(key: "sample_key_2"),
            Video(key: "sample_key_3"),
            Video(key: "sample_key_4"),
        ])
        viewModel = MovieDetailViewModel(movie: movie, source: source)
    }

    override func tearDown() {
        disposeBag = nil
        source = nil
        viewModel = nil
    }
    
    func test_movieImagePath() {
        XCTAssertEqual(viewModel.movieImagePath, "https://image.tmdb.org/t/p/w500/Poster", "viewModel.movieImagePath is not returning movie's posterPath")
    }
    
    func test_movieTitle() {
        XCTAssertEqual(viewModel.movieTitle, "title", "viewModel.movieTitle path is not returning movie's title")
    }
    
    func test_movieSubtitle() {
        XCTAssertEqual(viewModel.movieSubtitle, "Overview", "viewModel.movieSubtitle is not returning movie's overview")
    }
    
    func test_movieInfoSections() {
        XCTAssertEqual(viewModel.infoSections.count, 3, "viewModel.infoSections has not 3 objects")
    }
    
    func test_videosContent() {
        XCTAssertEqual(viewModel.videos.value.first!, "sample_key_1", "viewModel.videos is not returning the right key from video objects.")
    }
    
    func test_videoCount() {
        XCTAssertEqual(viewModel.videos.value.count, 4, "viewModel.videos has incorrect number of videos.")
    }
}
