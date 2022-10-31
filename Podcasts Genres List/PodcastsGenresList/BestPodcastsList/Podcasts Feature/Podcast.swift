// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct Podcast: Equatable {
    public let id: String
    public let title: String
    public let image: URL
    
    public init(id: String, title: String, image: URL) {
        self.id = id
        self.title = title
        self.image = image
    }
}
