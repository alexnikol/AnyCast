// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct PodcastImageViewModel<Image> {
    let title: String
    let image: Image?
    
    public init(title: String, image: Image?) {
        self.title = title
        self.image = image
    }
}
