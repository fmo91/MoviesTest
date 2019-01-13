//
//  Conn+RxSwift.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import RxSwift

extension RequestType {
    func rx_dispatch() -> Single<ResponseType> {
        return Single<ResponseType>.create { observer in
            let task = self.execute(
                onSuccess: { (response: ResponseType) in
                    observer(.success(response))
                },
                onError: { (error: Error) in
                    observer(.error(error))
                }
            )
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
