//
//  MoviesListBuilder.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class MoviesListBuilder {
    
    // MARK: - Attributes -
    private let moviesSource: Driver<[Movie]>
    
    // MARK: - Init -
    init(moviesSource: Driver<[Movie]>) {
        self.moviesSource = moviesSource
    }
    
    // MARK: - Build -
    func build() -> UIViewController {
        let viewModel = MoviesListViewModel(moviesSource: moviesSource)
        let viewController = MoviesListViewController(viewModel: viewModel)
        return viewController
    }
    
}
