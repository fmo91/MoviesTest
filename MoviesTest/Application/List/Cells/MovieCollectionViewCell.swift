//
//  MovieCollectionViewCell.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 12/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import DequeuableRegistrable

final class MovieCollectionViewCell: UICollectionViewCell, Dequeuable, Registrable {
    
    // MARK: - Views -
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieSubtitleLabel: UILabel!

    // MARK: - Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Configuration -
    func configure(with movie: MovieEntity) {
        movieImageView.load(movie.imagePath)
        movieTitleLabel.text = movie.title
        movieSubtitleLabel.text = movie.overview
    }
    
    func configureBorders() {
        contentView.layer.cornerRadius = 12.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

}
