// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModuleiOS

extension EpisodeCell {
    var titleText: String? {
        return titleLabel.text
    }
    
    var descriptionText: String? {
        return descriptionLabel.text
    }
    
    var audoLengthText: String? {
        return audioLengthLabel.text
    }
}
