//
//  MockNetworkDispatcher.swift
//  MoviesTestTests
//
//  Created by Fernando Ortiz on 17/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
@testable import MoviesTest

/**
 A network dispatcher that returns a predefined
 output injected in its constructor method.
 */
struct MockNetworkDispatcher: NetworkDispatcher {
    private let expectedOutput: NetworkResult
    
    @discardableResult
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> URLSessionDataTask? {
        switch expectedOutput {
        case .json(let json):
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                onSuccess(jsonData)
            } catch (let error) {
                onError(error)
            }
        case .error(let error):
            onError(error)
        }
        return nil
    }
    
    init (expectedOutput: NetworkResult) {
        self.expectedOutput = expectedOutput
    }
}

enum NetworkResult {
    case json(String)
    case error(Error)
}
