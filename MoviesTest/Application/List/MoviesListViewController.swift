//
//  MoviesListViewController.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import BouncyLayout
import RxSwift
import RxCocoa

final class MoviesListViewController: BaseViewController {
    
    // MARK: - Inner Types -
    private enum CollectionViewStyle {
        case grid, list
        
        var numberOfColumns: Int {
            switch self {
            case .grid: return 2
            case .list: return 1
            }
        }
        
        mutating func `switch`() {
            switch self {
            case .grid: self = .list
            case .list: self = .grid
            }
        }
    }
    
    // MARK: - Views -
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Attributes -
    private let viewModel: MoviesListViewModelType
    let didReachedEnd = PublishSubject<Void>()
    let cardTransitionAnimator = CardTransitionAnimator()
    
    private var collectionViewStyle: CollectionViewStyle = .list

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        viewModel.movies.asDriver()
            .drive(onNext: { [unowned self] (_) in
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarTransparent(true)
    }
    
    // MARK: - Init -
    init(viewModel: MoviesListViewModelType) {
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
    
    private func setupNavigationBar() {
        let buttonTitle: String = {
            switch collectionViewStyle {
            case .list: return "Show Grid"
            case .grid: return "Show List"
            }
        }()
        let layoutChangeBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(layoutChangeBarButtonItemPressed))
        parent?.navigationItem.rightBarButtonItem = layoutChangeBarButtonItem
    }
    
    // MARK: - Actions -
    @objc private func layoutChangeBarButtonItemPressed() {
        parent?.children.forEach({ (controller) in
            guard let listController = controller as? MoviesListViewController else {
                return
            }
            
            listController.collectionViewStyle.switch()
            listController.collectionView.setCollectionViewLayout(BouncyLayout(), animated: true)
            listController.collectionView.collectionViewLayout.invalidateLayout()
            listController.collectionView.visibleCells.forEach { (cell) in
                (cell as? MovieCollectionViewCell)?.configureBorders()
            }
        })
        setupNavigationBar()
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
        cell.configure(with: viewModel.movies.value[indexPath.row])
        cell.configureBorders()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = MovieDetailBuilder(movie: self.viewModel.movies.value[indexPath.row].movie, animator: self.cardTransitionAnimator).build()
        self.updateTransitionAnimator(for: indexPath)
        self.navigationController?.delegate = self
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [unowned self] in
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
            self.updateTransitionAnimator(for: indexPath)
        }
        self.navigationController?.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    private func updateTransitionAnimator(for indexPath: IndexPath) {
        guard let cellForIndex = collectionView.cellForItem(at: indexPath)
            , let attributes = collectionView.layoutAttributesForItem(at: indexPath)
            else {
                return
        }
        let convertedRect = collectionView.convert(attributes.frame, to: nil)
        
        self.cardTransitionAnimator.originRect = convertedRect
        self.cardTransitionAnimator.originView = (cellForIndex as! MovieCollectionViewCell)
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
        let interitemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let width: CGFloat = (collectionView.frame.width - layoutInsets.left - layoutInsets.right - (CGFloat(collectionViewStyle.numberOfColumns) - 1) * interitemSpacing) / CGFloat(collectionViewStyle.numberOfColumns)
        
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
        return 10.0
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
