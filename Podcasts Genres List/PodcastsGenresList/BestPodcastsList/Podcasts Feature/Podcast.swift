// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct Podcast: Equatable {
    let id: String
    let title: String
    let image: URL
    
    public init(id: String, title: String, image: URL) {
        self.id = id
        self.title = title
        self.image = image
    }
}
