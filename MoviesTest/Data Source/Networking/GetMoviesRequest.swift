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
            path: "\(RequestConstants.baseURL)/discover/movie?api_key=\(RequestConstants.apiKey)&language=en-US&sort_by=\(category.apiOption)&include_adult=false&page=\(page)",
            method: .get,
            params: nil,
            headers: nil
        )
    }
    
    init (category: Movie.Category, page: Int = 1) {
        self.category = category
        self.page = page
    }
}

private extension Movie.Category {
    var apiOption: String {
        switch self {
        case .popular   : return "popularity.desc"
        case .topRated  : return "vote_average.desc"
        case .upcoming  : return "release_date.desc"
        }
    }
}
