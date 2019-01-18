//
//  MockMoviesSource.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 17/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift
@testable import MoviesTest

enum Result<T> {
    case success(T)
    case failure(Error)
}

private extension Observable {
    static func from<T>(_ result: Result<T>) -> Observable<T> {
        switch result {
        case .success(let value):
            return .just(value)
        case .failure(let error):
            return .error(error)
        }
    }
}

final class MockMoviesSource: MoviesSource {
    var searchMoviesResult: Result<[Movie]>!
    var getMoviesResult: Result<[Movie]>!
    var getVideosResult: Result<[Video]>!
    
    func searchMovies(text: String, criteria: SearchCriteriaItem) -> Observable<[Movie]> {
        return Observable<[Movie]>.from(searchMoviesResult)
    }
    
    func getMovies(category: Movie.Category, page: Int?) -> Observable<[Movie]> {
        return Observable<[Movie]>.from(getMoviesResult)
    }
    
    func getVideos(movieId: Int) -> Observable<[Video]> {
        return Observable<[Video]>.from(getVideosResult)
    }
    
    init() {}
}
