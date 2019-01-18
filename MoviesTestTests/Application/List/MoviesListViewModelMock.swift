//
//  MoviesListViewModelMock.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 17/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
@testable import MoviesTest

final class MoviesListViewModelMock: MoviesListViewModelType {
    let movies: BehaviorRelay<[MovieEntity]>
    
    init (movies: BehaviorRelay<[MovieEntity]>) {
        self.movies = movies
    }
}
