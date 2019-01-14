//
//  Movie.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import CoreData

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
    
    let aPosterPath: String?
    var posterPath: String? {
        guard let _posterPath = aPosterPath else {
            return nil
        }
        return "https://image.tmdb.org/t/p/w500\(_posterPath)"
    }
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Double
    let video: Bool
    let voteAverage: Double
    
    init(
        posterPath: String?,
        adult: Bool,
        overview: String,
        releaseDate: Date,
        genreIds: [Int],
        id: Int,
        originalTitle: String,
        originalLanguage: String,
        title: String,
        backdropPath: String?,
        popularity: Double,
        video: Bool,
        voteAverage: Double
    ) {
        self.aPosterPath = posterPath
        self.adult = adult
        self.overview = overview
        self.releaseDate = ""
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
        case aPosterPath = "poster_path"
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

extension Movie {
    static func fromLocalMovie(_ localMovie: LocalMovie) -> Movie? {
        let movie = Movie(
            posterPath: localMovie.aPosterPath,
            adult: localMovie.adult,
            overview: localMovie.overview ?? "",
            releaseDate: Date(),
            genreIds: [],
            id: Int(localMovie.id),
            originalTitle: localMovie.originalTitle ?? "",
            originalLanguage: localMovie.originalLanguage ?? "",
            title: localMovie.title ?? "",
            backdropPath: localMovie.backdropPath,
            popularity: localMovie.popularity,
            video: localMovie.video,
            voteAverage: localMovie.voteAverage
        )
        
        return movie
    }
    func toLocalMovie() -> LocalMovie {
        let localMovie = LocalMovie(context: context)
        localMovie.aPosterPath = posterPath
        localMovie.adult = adult
        localMovie.overview = overview
        localMovie.releaseDate = releaseDate
        localMovie.genreIds = NSArray(array: genreIds.map { NSNumber(integerLiteral: $0) })
        localMovie.id = Int32(id)
        localMovie.originalTitle = originalTitle
        localMovie.originalLanguage = originalLanguage
        localMovie.title = title
        localMovie.backdropPath = backdropPath
        localMovie.popularity = popularity
        localMovie.video = video
        localMovie.voteAverage = voteAverage
        return localMovie
    }
}
