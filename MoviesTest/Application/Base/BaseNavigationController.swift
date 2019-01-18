//
//  BaseNavigationController.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

final class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.titleTextAttributes = [
            .font: UIFont(customFont: .pacificoRegular, size: 23.0),
            .foregroundColor: UIColor.custom.black
        ]
    }

    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            guard oldValue != statusBarStyle else { return }
            UIView.animate(withDuration: 0.3) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
}

extension UIViewController {
    func inBaseNavigation() -> BaseNavigationController {
        return BaseNavigationController(rootViewController: self)
    }
}

extension UIViewController {
    func setNavigationBarTransparent(_ transparent: Bool) {
        if transparent {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
            self.edgesForExtendedLayout = UIRectEdge.top
            
            navigationController?.setNeedsStatusBarAppearanceUpdate()
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.view.backgroundColor = .white
            
            navigationController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
