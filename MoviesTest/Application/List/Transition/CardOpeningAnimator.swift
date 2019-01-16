//
//  CardOpeningAnimator.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

final class CardTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var originRect: CGRect?
    var originView: MovieCollectionViewCell?
    var operation: UINavigationController.Operation?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let operation = self.operation else {
            return
        }
        let containerView = transitionContext.containerView
        guard let viewControllerFrom = transitionContext.viewController(forKey: .from)
            , let viewControllerTo = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        guard let originView = self.originView, let originRect = self.originRect else {
            return
        }
        guard let imageView = originView.movieImageView else {
            return
        }
        let copiedImageView = UIImageView(image: imageView.image)
        copiedImageView.contentMode = .scaleAspectFill
        copiedImageView.clipsToBounds = true
        switch operation {
        case .push:
            copiedImageView.frame = CGRect(x: originRect.minX, y: originRect.minY, width: originRect.width, height: imageView.frame.height)
        case .pop:
            copiedImageView.frame = CGRect(
                x: viewControllerTo.view.frame.minX,
                y: viewControllerTo.view.frame.minY,
                width: viewControllerTo.view.frame.width,
                height: MovieDetailViewController.topImageViewInitialHeight
            )
        case .none:
            return
        }
        [viewControllerFrom.view, viewControllerTo.view].forEach { $0.frame = containerView.frame }
        containerView.addSubview(viewControllerTo.view)
        containerView.addSubview(viewControllerFrom.view)
        containerView.addSubview(copiedImageView)
        let duration = transitionDuration(using: transitionContext)
        (viewControllerTo as? MovieDetailViewController)?.topImageView.alpha = 0.0
        UIView.animate(
            withDuration: duration,
            animations: {
                switch operation {
                case .push:
                    copiedImageView.frame = CGRect(
                        x: viewControllerTo.view.frame.minX,
                        y: viewControllerTo.view.frame.minY,
                        width: viewControllerTo.view.frame.width,
                        height: MovieDetailViewController.topImageViewInitialHeight
                    )
                case .pop:
                    copiedImageView.frame = CGRect(x: originRect.minX, y: originRect.minY, width: originRect.width, height: imageView.frame.height)
                    copiedImageView.alpha = 0.0
                case .none:
                    return
                }
                viewControllerFrom.view.alpha = 0.0
            },
            completion: { _ in
                (viewControllerTo as? MovieDetailViewController)?.topImageView.alpha = 1.0
                copiedImageView.removeFromSuperview()
                viewControllerFrom.view.alpha = 1.0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
