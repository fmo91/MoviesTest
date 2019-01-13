//
//  UIImageView+Kingfisher.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 13/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func load(_ imagePath: String?, placeholder: UIImage? = UIImage(named: "placeholder")) {
        guard let _imagePath = imagePath, let url = URL(string: _imagePath) else {
            self.image = placeholder
            return
        }
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.25))],
            progressBlock: nil,
            completionHandler: nil
        )
    }
            
    func cancelDownload() {
        kf.cancelDownloadTask()
    }
}
