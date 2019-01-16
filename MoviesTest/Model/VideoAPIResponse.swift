//
//  VideoAPIResponse.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

struct VideoAPIResponse: Codable {
    let id: Int
    let results: [Video]
}
