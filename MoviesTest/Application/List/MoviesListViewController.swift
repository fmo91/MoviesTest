//
//  MoviesListViewController.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MoviesListViewController: BaseViewController {
    
    // MARK: - Views -
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Attributes -
    private let viewModel: MoviesListViewModel
    
    let didReachedEnd = PublishSubject<Void>()
    
    let cardTransitionAnimator = CardTransitionAnimator()

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        viewModel.movies.asDriver()
            .drive(onNext: { [unowned self] (_) in
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarTransparent(true)
    }
    
    // MARK: - Init -
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup -
    private func setupCollectionView() {
        MovieCollectionViewCell.register(in: collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource -
extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MovieCollectionViewCell.dequeue(from: collectionView, for: indexPath)
        cell.contentView.layer.cornerRadius = 12.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.configure(with: viewModel.movies.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = MovieDetailBuilder(movie: viewModel.movies.value[indexPath.row].movie, animator: cardTransitionAnimator).build()
        guard let cellForIndex = collectionView.cellForItem(at: indexPath)
            , let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        else {
            return
        }
        let convertedRect = collectionView.convert(attributes.frame, to: nil)
        
        cardTransitionAnimator.originRect = convertedRect
        cardTransitionAnimator.originView = (cellForIndex as! MovieCollectionViewCell)
        
        navigationController?.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.value.count - 1 {
            didReachedEnd.onNext(())
        }
        
        let scaleFactor: CGFloat = 0.6
        cell.transform = CGAffineTransform.identity.scaledBy(x: scaleFactor, y: scaleFactor)
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.2) {
            cell.transform = .identity
            cell.alpha = 1.0
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -
extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layoutInsets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let width: CGFloat = collectionView.frame.width - layoutInsets.left - layoutInsets.right
        
        return CGSize(
            width   : width,
            height  : width * 1.2
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top     : 10.0,
            left    : 20.0,
            bottom  : 10.0,
            right   : 20.0
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

// MARK: - UINavigationControllerDelegate -
extension MoviesListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            cardTransitionAnimator.operation = operation
            return cardTransitionAnimator
        case .pop:
            cardTransitionAnimator.operation = operation
            return cardTransitionAnimator
        case .none:
            return nil
        }
    }
}
