// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModuleiOS

extension PodcastCell {
    var titleText: String? {
        return titleLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        thumbnailImageView.shimmeringContainer?.isShimmering == true
    }
}
