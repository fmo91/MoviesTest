//
//  SearchMoviesRequest.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

struct SearchMoviesRequest: RequestType {
    typealias ResponseType = PagedMoviesResponse
    
    let keyword: String
    
    var data: RequestData {
        return RequestData(
            path: "\(RequestConstants.baseURL)/search/movie?api_key=\(RequestConstants.apiKey)&query=\(keyword.replacingOccurrences(of: " ", with: "+"))",
            method: .get,
            params: nil,
            headers: nil
        )
    }
    
    init (keyword: String) {
        self.keyword = keyword
    }
}
