//
//  MoviesSearchListViewController.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MoviesSearchListViewController: BaseViewController {
    
    // MARK: - Views -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topSegmentedControl: UISegmentedControl!
    
    // MARK: - Attributes -
    var movies = BehaviorRelay<[SearchMovieEntity]>(value: [])
    let criteriaItems: [SearchCriteriaItem]
    let didSelectMovie = PublishSubject<SearchMovieEntity>()
    let didSelectCriteria = PublishSubject<SearchCriteriaItem>()

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        
        movies.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                let section = IndexSet.init(integer: 0)
                self?.tableView.reloadSections(section, with: .automatic)
            })
            .disposed(by: disposeBag)
        
        self.topSegmentedControl.removeAllSegments()
        criteriaItems
            .indexedForEach { [unowned self] (criteriaItem, index) in
                self.topSegmentedControl.insertSegment(withTitle: criteriaItem.title, at: index, animated: false)
            }
        self.topSegmentedControl.selectedSegmentIndex = 0
        
        self.topSegmentedControl.rx.controlEvent(.valueChanged)
            .map { [unowned self] in
                let selectedIndex = self.topSegmentedControl.selectedSegmentIndex
                let selectedCriteriaItem = self.criteriaItems[selectedIndex]
                return selectedCriteriaItem
            }
            .bind(to: didSelectCriteria)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Init -
    init(criteriaItems: [SearchCriteriaItem]) {
        self.criteriaItems = criteriaItems
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    private func setupTableView() {
        MovieSearchResultTableViewCell.register(in: tableView)
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension Reactive where Base: MoviesSearchListViewController {
    var movies: Binder<[SearchMovieEntity]> {
        return Binder(self.base) { (controller, newMovies) in
            controller.movies.accept(newMovies)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource -
extension MoviesSearchListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieSearchResultTableViewCell.dequeue(from: tableView)
        cell.configure(with: movies.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieSearchResultTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectMovie.onNext(movies.value[indexPath.row])
    }
}
