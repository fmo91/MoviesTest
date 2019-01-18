//
//  Result.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 17/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift

enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Observable {
    static func from<T>(_ result: Result<T>) -> Observable<T> {
        switch result {
        case .success(let value):
            return .just(value)
        case .failure(let error):
            return .error(error)
        }
    }
}
