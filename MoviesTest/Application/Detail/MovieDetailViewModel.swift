//
//  MovieDetailViewModel.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import RxSwift
import RxCocoa

final class MovieDetailViewModel {
    
    // MARK: - Attributes -
    private let disposeBag = DisposeBag()
    private let movie: Movie
    
    var movieImagePath: String {
        return movie.posterPath ?? ""
    }
    
    var movieTitle: String {
        return movie.title
    }
    
    var movieSubtitle: String {
        return movie.overview
    }
    
    var infoSections: [MovieDetailInfoSection] {
        return [
            MovieDetailInfoSection(title: "Adult", contents: movie.adult ? "Yes" : "No"),
            MovieDetailInfoSection(title: "Popularity", contents: movie.popularity.description),
            MovieDetailInfoSection(title: "Release Date", contents: movie.releaseDate.toDate?.toString ?? ""),
        ]
    }
    
    let videos = BehaviorRelay<[String]>(value: [])
    
    // MARK: - Init -
    init(movie: Movie, source: MoviesSource) {
        self.movie = movie
        
        source.getVideos(movieId: movie.id)
            .map { videos in
                videos.compactMap { video in
//                    video.key
                    video.id
                }
            }
            .catchErrorJustReturn([])
            .bind(to: videos)
            .disposed(by: disposeBag)
    }
    
}

private extension String {
    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}

private extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
