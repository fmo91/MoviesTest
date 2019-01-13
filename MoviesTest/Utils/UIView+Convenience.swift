//
//  UIView+Convenience.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func addShadow(shadowColor: CGColor? = nil, shadowOffset: CGSize? = nil, shadowRadius: CGFloat? = nil, shadowOpacity: CGFloat? = nil) -> UIView {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor ?? UIColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0).cgColor
        layer.shadowOffset = shadowOffset ?? CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = shadowRadius ?? 5.0
        layer.shadowOpacity = Float(shadowOpacity ?? 0.8)
        return self
    }
}
