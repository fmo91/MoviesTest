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
    func searchMovies(text: String, criteria: SearchCriteriaItem) -> Observable<[Movie]> {
        switch criteria {
        case .all: return performTextSearch(for: text)
        default: return performCategorySearch(for: text, criteria: criteria)
        }
    }
    
    private func performTextSearch(for text: String) -> Observable<[Movie]> {
        let fetch = NSFetchRequest<TextSearch>(entityName: "TextSearch")
        fetch.predicate = NSPredicate(format: "text = %@", text)
        let searchesThatMatch = try? context.fetch(fetch)
        if let result = searchesThatMatch?.first, let localMovies = (result.movies?.allObjects ?? []) as? [LocalMovie] {
            return .just(localMovies.compactMap(Movie.fromLocalMovie))
        } else {
            return .just([])
        }
    }
    
    private func performCategorySearch(for text: String, criteria: SearchCriteriaItem) -> Observable<[Movie]> {
        guard let category = criteriaToCategory(criteria) else {
            return .just([])
        }
        return getMovies(category: category, page: nil)
            .map { $0.filter { $0.title.contains(text) } }
    }
    
    private func criteriaToCategory(_ criteria: SearchCriteriaItem) -> Movie.Category? {
        switch criteria {
        case .all: return nil
        case .popular: return .popular
        case .topRated: return .topRated
        case .upcoming: return .upcoming
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
    
    func getVideos(movieId: Int) -> Observable<[Video]> {
        return .just([])
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
    
    func saveMovies(_ movies: [Movie], page: Int, forCategory category: Movie.Category) {
        let fetch = NSFetchRequest<CategorySearch>(entityName: "CategorySearch")
        fetch.predicate = NSPredicate(format: "category = %@", category.rawValue)
        let searchesThatMatch = try? context.fetch(fetch)
        
        guard let results = searchesThatMatch else {
            return
        }
        
        let localMovies = movies.map { $0.saveIfNotExistInDatabase(for: context) }
        
        if results.isEmpty {
            let entity = NSEntityDescription.entity(forEntityName: "CategorySearch", in: context)
            let search = NSManagedObject(entity: entity!, insertInto: context) as! CategorySearch
            search.setValue(category.rawValue, forKey: "category")
            localMovies.forEach { (localMovie) in
                search.addToMovies(localMovie)
            }
        } else if let firstResult = results.first {
            localMovies.forEach { (localMovie) in
                firstResult.addToMovies(localMovie)
            }
        }
        
        context.saveIfHasChanged()
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
