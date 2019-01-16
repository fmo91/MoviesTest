//
//  MovieDetailVideosTableViewCell.swift
//  MoviesTest
//
//  Created by Fernando Ortiz on 15/01/2019.
//  Copyright © 2019 Fernando Ortiz. All rights reserved.
//

import UIKit
import DequeuableRegistrable
import youtube_ios_player_helper

final class MovieDetailVideosTableViewCell: UITableViewCell, Dequeuable, Registrable {
    
    @IBOutlet weak var playerView: YTPlayerView!

    // MARK: - Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: - Configuration -
    func configure(with videoId: String) {
        playerView.loadVideo(byId: videoId, startSeconds: 0.0, suggestedQuality: .auto)
    }
    
    // MARK: - Size -
    static var height: CGFloat {
        return 190.0
    }
    
}
