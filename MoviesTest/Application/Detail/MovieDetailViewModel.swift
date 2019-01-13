//
//  MovieDetailViewModel.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import RxSwift
import RxCocoa

final class MovieDetailViewModel {
    
    // MARK: - Attributes -
    private let movie: Movie
    
    var movieImagePath: String {
        return movie.posterPath ?? ""
    }
    
    var movieTitle: String {
        return movie.title
    }
    
    var movieSubtitle: String {
        return movie.overview
    }
    
    // MARK: - Init -
    init(movie: Movie) {
        self.movie = movie
    }
    
}
