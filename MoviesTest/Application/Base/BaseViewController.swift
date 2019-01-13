//
//  BaseViewController.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 11/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import RxSwift

internal class BaseViewController: UIViewController {
    // MARK: - Attributes -
    internal let disposeBag = DisposeBag()
    internal var statusBarHeight: CGFloat { return UIApplication.shared.statusBarFrame.height }
    internal var navigationBarHeight: CGFloat { return (navigationController?.navigationBar.frame.height ?? 0) }
    
    // MARK: - Views -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title   : "",
            style   : .plain,
            target  : nil,
            action  : nil
        )
    }
    
    // MARK: - Init -
    init(nibName: String? = nil) {
        let name = String(describing: type(of: self))
        super.init(nibName: nibName ?? name, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Utils -
    func setStatusBarStyle(_ statusBarStyle: UIStatusBarStyle) {
        guard let baseNavigationController = self.navigationController as? BaseNavigationController else { return }
        baseNavigationController.statusBarStyle = statusBarStyle
    }
    
}
