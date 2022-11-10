// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModuleiOS

extension EpisodeCell {
    var titleText: String? {
        return titleLabel.text
    }
    
    var descriptionText: String? {
        return desciptionView.attributedText.string
    }
    
    var audoLengthText: String? {
        return audioLengthLabel.text
    }
    
    var publishDateText: String? {
        return publishDateLabel.text
    }
}
