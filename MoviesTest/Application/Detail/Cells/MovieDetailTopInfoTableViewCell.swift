//
//  MovieDetailTopInfoTableViewCell.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import DequeuableRegistrable

final class MovieDetailTopInfoTableViewCell: UITableViewCell, Dequeuable, Registrable {

    // MARK: - Views -
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieSubtitleLabel: UILabel!
    
    // MARK: - Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Configuration -
    func configure(title: String, subtitle: String) {
        movieTitleLabel.text = title
        movieSubtitleLabel.text = subtitle
    }
    
    // MARK: - Size -
    static var height: CGFloat {
        return UITableView.automaticDimension
    }
    
}
