//
//  MoviesSource.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift

protocol MoviesSource {
    func searchMovies(text: String) -> Single<[Movie]>
    func getMovies(category: Movie.Category) -> Single<[Movie]>
}
