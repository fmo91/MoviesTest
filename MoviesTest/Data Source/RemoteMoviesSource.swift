//
//  RemoteMoviesSource.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift

struct RemoteMoviesSource: MoviesSource {
    func searchMovies(text: String, criteria: SearchCriteriaItem) -> Observable<[Movie]> {
        guard criteria == .all else {
            return .just([])
        }
        
        if text.isEmpty {
            return .just([])
        }
        
        return SearchMoviesRequest(keyword: text).rx_dispatch()
            .asObservable()
            .map { $0.results }
    }
    func getMovies(category: Movie.Category, page: Int?) -> Observable<[Movie]> {
        return category.toRequestType(page: page).rx_dispatch()
            .asObservable()
            .map { $0.results }
    }
    func getVideos(movieId: Int) -> Observable<[Video]> {
        return GetVideosRequest(movieId: movieId).rx_dispatch()
            .asObservable()
            .map { $0.results }
    }
}

// Type-Erased RequestType
struct AnyRequestType<T: Codable>: RequestType {
    let data: RequestData
    
    typealias ResponseType = T
    
    init<U: RequestType>(_ requestType: U) where U.ResponseType == ResponseType {
        data = requestType.data
    }
}

private extension Movie.Category {
    func toRequestType(page: Int?) -> AnyRequestType<PagedMoviesResponse> {
        switch self {
        case .popular: return AnyRequestType(GetPopularMoviesRequest(page: page))
        case .topRated: return AnyRequestType(GetTopRatedMoviesRequest(page: page))
        case .upcoming: return AnyRequestType(GetUpcomingMoviesRequest(page: page))
        }
    }
}
