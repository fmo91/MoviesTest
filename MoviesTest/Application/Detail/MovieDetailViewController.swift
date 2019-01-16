//
//  MovieDetailViewController.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    
    // MARK: - Views -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var topImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Attributes -
    private let viewModel: MovieDetailViewModel
    static let topImageViewInitialHeight: CGFloat = 270.0

    // MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = [.top]
        
        setupTableView()
        topImageView.load(viewModel.movieImagePath)
        
        topImageViewHeightConstraint.constant = MovieDetailViewController.topImageViewInitialHeight
        
        let normalizedOffset = tableView.rx.contentOffset
            .map { [unowned self] offset in offset.y + self.statusBarHeight + self.navigationBarHeight }
            
        normalizedOffset
            .map { normalizedOffset in -CGFloat.maximum(normalizedOffset, 0.0) * 0.5 }
            .bind(to: topImageViewTopConstraint.rx.constant)
            .disposed(by: disposeBag)
        
        normalizedOffset
            .map { normalizedOffset in -CGFloat.minimum(normalizedOffset, 0.0) + MovieDetailViewController.topImageViewInitialHeight }
            .bind(to: topImageViewHeightConstraint.rx.constant)
            .disposed(by: disposeBag)
        
        viewModel.videos.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBarStyle(.lightContent)
    }
    
    // MARK: - Init -
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Configuration -
    func setupTableView() {
        MovieDetailTopInfoTableViewCell.register(in: tableView)
        MovieDetailInfoTableViewCell.register(in: tableView)
        MovieDetailVideosTableViewCell.register(in: tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

private enum Section: Int, ReusableViewEnum {
    case  topImageView = 0
        , topInfo
        , info
        , videos
}

// MARK: - UITableViewDelegate, UITableViewDataSource -
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.build(with: section) {
        case .topImageView:
            return 1
        case .topInfo:
            return 1
        case .info:
            return viewModel.infoSections.count
        case .videos:
            return viewModel.videos.value.isEmpty ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section.build(with: indexPath.section) {
        case .topImageView:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            [cell, cell.contentView].forEach { $0.backgroundColor = .clear }
            return cell
        case .topInfo:
            let cell = MovieDetailTopInfoTableViewCell.dequeue(from: tableView)
            cell.configure(title: viewModel.movieTitle, subtitle: viewModel.movieSubtitle)
            return cell
        case .info:
            let cell = MovieDetailInfoTableViewCell.dequeue(from: tableView)
            cell.configure(with: viewModel.infoSections[indexPath.row])
            return cell
        case .videos:
            let cell = MovieDetailVideosTableViewCell.dequeue(from: tableView)
            cell.configure(with: viewModel.videos.value.first!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section.build(with: indexPath.section) {
        case .topImageView:
            return MovieDetailViewController.topImageViewInitialHeight - navigationBarHeight - statusBarHeight
        case .topInfo:
            return MovieDetailTopInfoTableViewCell.height
        case .info:
            return MovieDetailInfoTableViewCell.height
        case .videos:
            return MovieDetailVideosTableViewCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
