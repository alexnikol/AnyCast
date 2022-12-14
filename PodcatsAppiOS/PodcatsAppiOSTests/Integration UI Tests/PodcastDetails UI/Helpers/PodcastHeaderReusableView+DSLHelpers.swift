// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModuleiOS

extension PodcastHeaderReusableView {
    var titleText: String? {
        return titleLabel.text
    }
    
    var authorText: String? {
        return authorLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        imageView.imageInnerContainer.isShimmering
    }
}
