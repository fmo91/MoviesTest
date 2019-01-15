//
//  LocalMoviesSource.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

struct LocalMoviesSource: MoviesSource {
    func searchMovies(text: String) -> Observable<[Movie]> {
        let fetch = NSFetchRequest<TextSearch>(entityName: "TextSearch")
        fetch.predicate = NSPredicate(format: "text = %@", text)
        let searchesThatMatch = try? context.fetch(fetch)
        if let result = searchesThatMatch?.first, let localMovies = (result.movies?.allObjects ?? []) as? [LocalMovie] {
            return .just(localMovies.compactMap(Movie.fromLocalMovie))
        } else {
            return .just([])
        }
    }
    
    func getMovies(category: Movie.Category, page: Int?) -> Observable<[Movie]> {
        let fetch = NSFetchRequest<CategorySearch>(entityName: "CategorySearch")
        fetch.predicate = NSPredicate(format: "category = %@", category.rawValue)
        let searchesThatMatch = try? context.fetch(fetch)
        if let result = searchesThatMatch?.first, let localMovies = (result.movies?.allObjects ?? []) as? [LocalMovie] {
            return .just(localMovies.compactMap(Movie.fromLocalMovie))
        } else {
            return .just([])
        }
    }
    
    func saveMovies(_ movies: [Movie], forSearch text: String) {
        let fetch = NSFetchRequest<TextSearch>(entityName: "TextSearch")
        fetch.predicate = NSPredicate(format: "text = %@", text)
        let searchesThatMatch = try? context.fetch(fetch)
        if let results = searchesThatMatch, results.isEmpty {
            let localMovies = movies.map { $0.saveIfNotExistInDatabase(for: context) }
            let entity = NSEntityDescription.entity(forEntityName: "TextSearch", in: context)
            let search = NSManagedObject(entity: entity!, insertInto: context) as! TextSearch
            search.setValue(text, forKey: "text")
            localMovies.forEach { (localMovie) in
                search.addToMovies(localMovie)
            }
            context.saveIfHasChanged()
        }
    }
    
    func saveMovies(_ movies: [Movie], forCategory category: Movie.Category) {
        let fetch = NSFetchRequest<CategorySearch>(entityName: "CategorySearch")
        fetch.predicate = NSPredicate(format: "category = %@", category.rawValue)
        let searchesThatMatch = try? context.fetch(fetch)
        if let results = searchesThatMatch, results.isEmpty {
            let localMovies = movies.map { $0.saveIfNotExistInDatabase(for: context) }
            let entity = NSEntityDescription.entity(forEntityName: "CategorySearch", in: context)
            let search = NSManagedObject(entity: entity!, insertInto: context) as! CategorySearch
            search.setValue(category.rawValue, forKey: "category")
            localMovies.forEach { (localMovie) in
                search.addToMovies(localMovie)
            }
            context.saveIfHasChanged()
        }
    }
}

private extension Movie {
    @discardableResult
    func saveIfNotExistInDatabase(for context: NSManagedObjectContext) -> LocalMovie {
        let fetch = NSFetchRequest<LocalMovie>(entityName: "LocalMovie")
        fetch.predicate = NSPredicate(format: "id = %@", NSNumber(integerLiteral: self.id))
        let localMoviesThatMatch = try? context.fetch(fetch)
        if let localMovie = localMoviesThatMatch?.first {
            return localMovie
        } else {
            let localMovie = self.toLocalMovie(in: context)
            return localMovie
        }
    }
}
