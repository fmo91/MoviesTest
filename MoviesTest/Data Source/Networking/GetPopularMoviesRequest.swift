//
//  GetPopularMoviesRequest.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 17/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

struct GetPopularMoviesRequest: RequestType {
    typealias ResponseType = PagedMoviesResponse
    
    let page: Int
    
    var data: RequestData {
        return RequestData(
            path: "\(RequestConstants.baseURL)/movie/popular",
            method: .get,
            params: [
                "api_key"       : RequestConstants.apiKey,
                "language"      : "en-US",
                "include_adult" : "false",
                "page"          : page.description
            ],
            headers: nil
        )
    }
    
    init (page: Int? = 1) {
        self.page = page ?? 1
    }
}
