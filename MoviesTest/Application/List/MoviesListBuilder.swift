//
//  MoviesListBuilder.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import UIKit

final class MoviesListBuilder {
    
    // MARK: - Attributes -
    private let category: Movie.Category
    
    // MARK: - Init -
    init(category: Movie.Category) {
        self.category = category
    }
    
    // MARK: - Build -
    func build() -> UIViewController {
        let viewModel = MoviesListViewModel(source: RemoteMoviesSource(), category: category)
        let viewController = MoviesListViewController(viewModel: viewModel)
        return viewController
    }
}
