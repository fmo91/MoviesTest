//
//  UIView+Autolayout.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

extension UIView {
    func addMatchingSize(inside anotherView: UIView) {
        anotherView.addSubview(self)
        [self, anotherView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        [
            self.topAnchor.constraint(equalTo: anotherView.topAnchor),
            self.leadingAnchor.constraint(equalTo: anotherView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: anotherView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: anotherView.bottomAnchor),
        ].forEach { $0.isActive = true }
    }
}

extension UIViewController {
    func embed(in anotherViewController: UIViewController, onView view: UIView?) {
        anotherViewController.addChild(self)
        self.view.addMatchingSize(inside: view ?? anotherViewController.view)
        didMove(toParent: anotherViewController)
    }
}

extension UIView {
    @discardableResult
    func sv(_ subviews: [UIView]) -> UIView {
        for subview in subviews {
            addSubview(subview)
        }
        return self
    }
}
