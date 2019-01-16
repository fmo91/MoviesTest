//
//  MovieDetailInfoTableViewCell.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import DequeuableRegistrable

final class MovieDetailInfoTableViewCell: UITableViewCell, Dequeuable, Registrable {
    
    // MARK: - Views -
    @IBOutlet weak var infoLabel: UILabel!

    // MARK: - Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Configuration -
    func configure(with info: MovieDetailInfoSection) {
        let attributedString = NSMutableAttributedString(
            string: "\(info.title): ",
            attributes: [
                .font: UIFont(customFont: .openSansBold, size: 14.0),
                .foregroundColor: UIColor.custom.black,
            ]
        )
        
        attributedString.append(NSAttributedString(
            string: info.contents,
            attributes: [
                .font: UIFont(customFont: .openSansRegular, size: 14.0),
                .foregroundColor: UIColor.custom.darkGray,
            ]
        ))
        
        infoLabel.attributedText = attributedString
    }
    
    // MARK: - Size -
    static var height: CGFloat {
        return UITableView.automaticDimension
    }
    
}
