//
//  Array+Convenience.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation

extension Array {
    func indexedForEach (_ action: (Element, Int) -> Void) {
        for (index, element) in self.enumerated() {
            action(element, index)
        }
    }
}
