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
    private let animator: CardTransitionAnimator?
    
    // MARK: - Init -
    init(movie: Movie, animator: CardTransitionAnimator?) {
        self.movie = movie
        self.animator = animator
    }
    
    // MARK: - Builder -
    func build() -> UIViewController {
        let viewModel = MovieDetailViewModel(movie: movie, source: CacheableMoviesSource())
        let viewController = MovieDetailViewController(viewModel: viewModel, animator: animator)
        return viewController
    }
}
