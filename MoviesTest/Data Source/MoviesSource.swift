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
    func searchMovies(text: String, criteria: SearchCriteriaItem) -> Observable<[Movie]>
    func getMovies(category: Movie.Category, page: Int?) -> Observable<[Movie]>
    func getVideos(movieId: Int) -> Observable<[Video]>
}
