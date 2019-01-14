//
//  Movie.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import CoreData

final public class Movie: NSManagedObject, Decodable {
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
    
    @NSManaged var aPosterPath: String?
    var posterPath: String? {
        guard let _posterPath = aPosterPath else {
            return nil
        }
        return "https://image.tmdb.org/t/p/w500\(_posterPath)"
    }
    @NSManaged var adult: Bool
    @NSManaged var overview: String
    @NSManaged var releaseDate: String
    @NSManaged var genreIds: NSArray
    @NSManaged var id: Int32
    @NSManaged var originalTitle: String
    @NSManaged var originalLanguage: String
    @NSManaged var title: String
    @NSManaged var backdropPath: String?
    @NSManaged var popularity: Double
    @NSManaged var video: Bool
    @NSManaged var voteAverage: Double
    
    required convenience public init(from decoder: Decoder) throws {
        guard
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)
        else {
            fatalError()
        }
        
        self.init(entity: entity, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        aPosterPath = try values.decode(String.self, forKey: .aPosterPath)
        adult = try values.decode(Bool.self, forKey: .adult)
        overview = try values.decode(String.self, forKey: .overview)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
//        genreIds
//        id = Int32(try values.decode(Int.self, forKey: .id))
        originalTitle = try values.decode(String.self, forKey: .originalTitle)
        originalLanguage = try values.decode(String.self, forKey: .originalLanguage)
        title = try values.decode(String.self, forKey: .title)
        backdropPath = try values.decode(String.self, forKey: .backdropPath)
//        popularity = try values.decode(Double.self, forKey: .popularity)
        video = try values.decode(Bool.self, forKey: .video)
//        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
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

extension Movie: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(aPosterPath, forKey: .aPosterPath)
        try container.encode(adult, forKey: .adult)
        try container.encode(overview, forKey: .overview)
        try container.encode(releaseDate, forKey: .releaseDate)
//        try container.encode(genreIds, forKey: .genreIds)
        try container.encode(id, forKey: .id)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(originalLanguage, forKey: .originalLanguage)
        try container.encode(title, forKey: .title)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(video, forKey: .video)
        try container.encode(voteAverage, forKey: .voteAverage)
    }
}
