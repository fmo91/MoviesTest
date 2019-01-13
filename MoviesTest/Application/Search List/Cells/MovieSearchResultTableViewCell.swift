//
//  MovieSearchResultTableViewCell.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import DequeuableRegistrable

final class MovieSearchResultTableViewCell: UITableViewCell, Dequeuable, Registrable {
    
    // MARK: - Views -
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieSubtitleLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.cancelDownload()
    }
    
    // MARK: - Configuration -
    func configure(with movie: SearchMovieEntity) {
        movieTitleLabel.text = movie.title
        movieSubtitleLabel.text = movie.subtitle
        movieImageView.load(movie.imagePath)
    }
    
    // MARK: - Size -
    static var height: CGFloat {
        return 44.0
    }
    
}
