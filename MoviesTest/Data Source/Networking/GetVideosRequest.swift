//
//  GetVideosRequest.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

struct GetVideosRequest: RequestType {
    typealias ResponseType = VideoAPIResponse
    
    let movieId: Int
    
    var data: RequestData {
        return RequestData(
            path: "\(RequestConstants.baseURL)/movie/\(movieId)/videos",
            method: .get,
            params: [
                "api_key": RequestConstants.apiKey,
                "language": "en-US"
            ],
            headers: nil
        )
    }
    
    init(movieId: Int) {
        self.movieId = movieId
    }
}
