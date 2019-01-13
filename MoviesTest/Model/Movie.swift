//
//  Movie.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

final public class Movie: Codable {
    public enum Category: CaseIterable {
        case popular, topRated, upcoming
        
        var displayableName: String {
            switch self {
            case .popular: return "Popular"
            case .topRated: return "Top Rated"
            case .upcoming: return "Upcoming"
            }
        }
    }
    
    let posterPath: String
    let adult: Bool
    let overview: String
    let releaseDate: Date
    let genreIds: [Int]
    let id: String
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String
    let popularity: Double
    let video: Bool
    let voteAverage: Double
    
    init(
        posterPath: String,
        adult: Bool,
        overview: String,
        releaseDate: Date,
        genreIds: [Int],
        id: String,
        originalTitle: String,
        originalLanguage: String,
        title: String,
        backdropPath: String,
        popularity: Double,
        video: Bool,
        voteAverage: Double
    ) {
        self.posterPath = posterPath
        self.adult = adult
        self.overview = overview
        self.releaseDate = releaseDate
        self.genreIds = genreIds
        self.id = id
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.title = title
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.video = video
        self.voteAverage = voteAverage
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult = "adult"
        case overview = "overview"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id = "id"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title = "title"
        case backdropPath = "backdrop_path"
        case popularity = "popularity"
        case video = "video"
        case voteAverage = "vote_average"
    }
}
