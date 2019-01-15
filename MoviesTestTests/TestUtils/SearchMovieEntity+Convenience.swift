//
//  SearchMovieEntity+Convenience.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
@testable import MoviesTest

extension SearchMovieEntity {
    static var empty: SearchMovieEntity {
        return SearchMovieEntity(movie: nil, imagePath: "", title: "", subtitle: "")
    }
}
