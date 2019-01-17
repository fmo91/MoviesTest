//
//  SearchCriteriaItem.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 16/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

enum SearchCriteriaItem: CaseIterable {
    case all, popular, topRated, upcoming
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
}

extension SearchCriteriaItem: Equatable, Hashable {
    static func == (lhs: SearchCriteriaItem, rhs: SearchCriteriaItem) -> Bool {
        return lhs.title == rhs.title
    }
}
