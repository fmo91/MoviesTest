//
//  Video.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

struct Video: Codable {
    let id: String?
    let iso639: String?
    let iso3166: String?
    let key: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
 
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case iso639 = "iso_639_1"
        case iso3166 = "iso_3166_1"
        case key = "key"
        case name = "name"
        case site = "site"
        case size = "size"
        case type = "type"
    }
}
