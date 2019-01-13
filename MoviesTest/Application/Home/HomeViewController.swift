//
//  HomeViewController.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    // MARK: - Views -
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var searchResultsContainer: UIView!
    @IBOutlet weak var categoriesSegmentedControl: BottomLinedSegmentedControl!
    
    @IBOutlet weak var popularMoviesContainer: UIView!
    @IBOutlet weak var topRatedMoviesContainer: UIView!
    @IBOutlet weak var upcomingMoviesContainer: UIView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private weak var searchListViewController: MoviesSearchListViewController!
    
    private weak var popularMoviesViewController: UIViewController!
    private weak var topRatedMoviesViewController: UIViewController!
    private weak var upcomingMoviesViewController: UIViewController!
    
    // MARK: - Attributes -
    private let viewModel: HomeViewModel

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "MOVIES TEST"
        
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
                let viewController = MovieDetailBuilder(movie: movie.movie).build()
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.searchResult
            .drive(searchListViewController.rx.movies)
            .disposed(by: disposeBag)
        
        viewModel.searchResult
            .map { $0.isEmpty }
            .drive (onNext: { [unowned self] emptyResults in
                self.searchResultsContainer.isHidden = emptyResults
                self.mainContainer.isHidden = !emptyResults
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarStyle(.default)
    }
    
    // MARK: - Init -
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup -
    private func setupSearchController() {
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
        let _popularMoviesViewController = MoviesListBuilder(category: .popular).build()
        let _topRatedMoviesViewController = MoviesListBuilder(category: .topRated).build()
        let _upcomingMoviesViewController = MoviesListBuilder(category: .upcoming).build()
        
        _popularMoviesViewController.embed(in: self, onView: popularMoviesContainer)
        _topRatedMoviesViewController.embed(in: self, onView: topRatedMoviesContainer)
        _upcomingMoviesViewController.embed(in: self, onView: upcomingMoviesContainer)
        
        popularMoviesViewController = _popularMoviesViewController
        topRatedMoviesViewController = _topRatedMoviesViewController
        upcomingMoviesViewController = _upcomingMoviesViewController
    }
    
}
