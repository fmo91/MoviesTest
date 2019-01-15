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
    
    // MARK: - Attributes -
    var movies = BehaviorRelay<[SearchMovieEntity]>(value: [])
    
    let didSelectMovie = PublishSubject<SearchMovieEntity>()

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        
        movies.asObservable()
            .subscribe(onNext: { [weak self] (_) in
//                self?.tableView.reloadData()
                let section = IndexSet.init(integer: 0)
                self?.tableView.reloadSections(section, with: .automatic)
            }) 
            .disposed(by: disposeBag)
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
