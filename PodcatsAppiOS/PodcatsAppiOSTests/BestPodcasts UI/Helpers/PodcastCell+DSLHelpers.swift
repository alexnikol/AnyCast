// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsListiOS

extension PodcastCell {
    var titleText: String? {
        return titleLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        imageContainer.isShimmering
    }
}
