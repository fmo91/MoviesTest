//
//  MovieDetailBuilder.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

final class MovieDetailBuilder {
    // MARK: - Attributes -
    private let movie: Movie
    
    // MARK: - Init -
    init(movie: Movie) {
        self.movie = movie
    }
    
    // MARK: - Builder -
    func build() -> UIViewController {
        let viewModel = MovieDetailViewModel(movie: movie)
        let viewController = MovieDetailViewController(viewModel: viewModel)
        return viewController
    }
}
