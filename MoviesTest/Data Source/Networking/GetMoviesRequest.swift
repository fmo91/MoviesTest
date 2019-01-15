//
//  GetMoviesRequest.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

struct GetMoviesRequest: RequestType {
    typealias ResponseType = PagedMoviesResponse
    
    let category: Movie.Category
    let page: Int
    
    var data: RequestData {
        return RequestData(
            path: "\(RequestConstants.baseURL)/discover/movie",
            method: .get,
            params: {
                var params = [
                    "api_key"       : RequestConstants.apiKey,
                    "language"      : "en-US",
                    "include_adult" : "false",
                    "page"          : page.description
                ]
                for (key, value) in category.apiOptions {
                    params[key] = value
                }
                return params
            }(),
            headers: nil
        )
    }
    
    init (category: Movie.Category, page: Int? = 1) {
        self.category = category
        self.page = page ?? 1
    }
}

private extension Movie.Category {
    var apiOptions: [String: String] {
        switch self {
        case .popular   : return ["sort_by": "popularity.desc"]
        case .topRated  : return ["sort_by": "vote_average.desc"]
        case .upcoming  : return ["sort_by": "release_date.desc"]
        }
    }
}
