//
//  MovieDetailSectionHeaderTextTableViewCell.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 16/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import DequeuableRegistrable

final class MovieDetailSectionHeaderTextTableViewCell: UITableViewCell, Dequeuable, Registrable {
    
    // MARK: - Views -
    @IBOutlet weak var headerLabel: UILabel!

    // MARK: - Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Configuration -
    func configure(with title: String) {
        self.headerLabel.text = title
    }
    
    // MARK: - Size -
    static var height: CGFloat {
        return 40.0
    }
    
}
