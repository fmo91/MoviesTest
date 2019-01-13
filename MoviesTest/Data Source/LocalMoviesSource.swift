//
//  LocalMoviesSource.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift

struct LocalMoviesSource: MoviesSource {
    private var sampleMovie: Movie {
        return Movie (
            posterPath: "https://as.com/tikitakas/imagenes/2017/12/12/portada/1513084749_554862_1513085177_noticia_normal.jpg",
            adult: false,
            overview: "A really good movie about a group of kids that good movie about a group of kids that good movie about a group of kids that good movie about a group of kids that good movie about a group of kids that good movie about a group of kids that good movie about a group of kids that good movie about a group of kids that good movie about a group of kids that ",
            releaseDate: Date(),
            genreIds: [],
            id: "123123",
            originalTitle: "Stranger Things",
            originalLanguage: "en",
            title: "Stranger Things",
            backdropPath: "",
            popularity: 1.0,
            video: true,
            voteAverage: 5.0
        )
    }
    
    func searchMovies(text: String) -> Single<[Movie]> {
        let repeatingMovie = sampleMovie
        let numberOfMovies = text.isEmpty ? 0 : (10 - text.count)
        let sampleMovies = Array<Movie>.init(
            repeating: repeatingMovie,
            count: numberOfMovies
        )
        return .just(sampleMovies)
    }
    func getMovies(category: Movie.Category) -> Single<[Movie]> {
        let repeatingMovie = sampleMovie
        let numberOfMovies = 5
        let sampleMovies = Array<Movie>.init(
            repeating: repeatingMovie,
            count: numberOfMovies
        )
        return .just(sampleMovies)
    }
}
