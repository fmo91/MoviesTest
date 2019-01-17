//
//  HomeViewController.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController: BaseViewController {
    
    // MARK: - Views -
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var categoriesViewControllersContainerView: UIStackView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var searchResultsContainer: UIView!
    @IBOutlet weak var categoriesSegmentedControl: BottomLinedSegmentedControl!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    weak var searchListViewController: MoviesSearchListViewController!
    var categoriesViewControllers: [UIViewController] = []
    
    // MARK: - Attributes -
    private let viewModel: HomeViewModelType

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies Test"
        
        categoriesSegmentedControl.addShadow()
        self.setupSearchController()
        self.addSearchListViewController()
        self.addCategoriesControllers()
        
        categoriesSegmentedControl.items = Movie.Category.allCases
            .map { $0.displayableName.uppercased() }
        
        // Bindings
        searchController.searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        searchListViewController.didSelectMovie.asObservable()
            .subscribe(onNext: { [weak self] (movie: SearchMovieEntity) in
                let viewController = MovieDetailBuilder(movie: movie.movie, animator: nil).build()
                self?.navigationController?.delegate = nil
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.searchResult
            .drive(searchListViewController.rx.movies)
            .disposed(by: disposeBag)
        
        Observable<Bool>
            .merge([
                searchController.searchBar.rx.delegate.methodInvoked(#selector(UISearchBarDelegate.searchBarTextDidBeginEditing(_:))).map { _ in true },
                searchController.searchBar.rx.cancelButtonClicked.asObservable().map { false },
            ])
            .subscribe(onNext: { [unowned self] (shouldShowSearchResults: Bool) in
                self.searchResultsContainer.isHidden = !shouldShowSearchResults
                self.mainContainer.isHidden = shouldShowSearchResults
            })
            .disposed(by: disposeBag)
        
        containerScrollView.rx.contentOffset
            .map { $0.x }
            .map { (offset) -> Int in
                return Int((offset / self.containerScrollView.frame.width).rounded())
            }
            .subscribe(onNext: { [unowned self] (index: Int) in
                self.categoriesSegmentedControl.setSelectedItem(index)
            })
            .disposed(by: disposeBag)
        
        containerScrollView.rx.contentOffset
            .map { $0.x }
            .map { offset in offset / self.containerScrollView.frame.width }
            .bind(to: categoriesSegmentedControl.rx.progress)
            .disposed(by: disposeBag)
        
        categoriesSegmentedControl.itemSelected
            .map { [unowned self] in CGFloat($0) * self.view.frame.width }
            .map { CGPoint(x: $0, y: 0) }
            .subscribe(onNext: { [unowned self] (newContentOffset: CGPoint) in
                self.containerScrollView.setContentOffset(newContentOffset, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarStyle(.default)
    }
    
    // MARK: - Init -
    init(viewModel: HomeViewModelType) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup -
    private func setupSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func addSearchListViewController() {
        let _searchListViewController = MoviesSearchListViewController()
        _searchListViewController.embed(in: self, onView: searchResultsContainer)
        searchListViewController = _searchListViewController
    }
    
    private func addCategoriesControllers() {
        let viewControllers = Movie.Category.allCases
            .map { self.viewModel.source(for: $0) }
            .map { MoviesListBuilder(moviesSource: $0).build() }
        
        for (index, controller) in viewControllers.enumerated() {
            addCategoryViewController(controller)
            
            let category = Movie.Category.allCases[index]
            controller.didReachedEnd.asObservable()
                .map { category }
                .bind(to: viewModel.didReachedEndForCategory)
                .disposed(by: disposeBag)
        }
        
        categoriesViewControllers = viewControllers
    }
    
    private func addCategoryViewController(_ controller: UIViewController) {
        let container = UIView()
        self.categoriesViewControllersContainerView.addArrangedSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        [
            container.heightAnchor.constraint(equalTo: self.containerScrollView.heightAnchor),
            container.widthAnchor.constraint(equalTo: self.containerScrollView.widthAnchor),
            ].forEach { $0.isActive = true }
        controller.embed(in: self, onView: container)
    }
    
}
