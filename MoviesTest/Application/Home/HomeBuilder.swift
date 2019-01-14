//
//  HomeBuilder.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

final class HomeBuilder {
    func build() -> UIViewController {
        let source = CacheableMoviesSource()
        let viewModel = HomeViewModel(source: source)
        let viewController = HomeViewController(viewModel: viewModel)
        return viewController
    }
}
