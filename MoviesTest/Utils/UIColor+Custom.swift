//
//  UIColor+Custom.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

extension UIColor {
    struct custom {
        static var black: UIColor {
            return UIColor(named: "Black") ?? .clear
        }
        static var darkGray: UIColor {
            return UIColor(named: "Dark Gray") ?? .clear
        }
    }
}
