//
//  MovieDetailViewModelMock.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 17/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxTest
@testable import MoviesTest

final class MovieDetailViewModelMock: MovieDetailViewModelType {
    var movieImagePath: String
    var movieTitle: String
    var movieSubtitle: String
    var infoSections: [MovieDetailInfoSection]
    var videos: BehaviorRelay<[String]>
    
    init(
        movieImagePath: String,
        movieTitle: String,
        movieSubtitle: String,
        infoSections: [MovieDetailInfoSection],
        videos: BehaviorRelay<[String]>
    ) {
        self.movieImagePath = movieImagePath
        self.movieTitle = movieTitle
        self.movieSubtitle = movieSubtitle
        self.infoSections = infoSections
        self.videos = videos
    }
}
