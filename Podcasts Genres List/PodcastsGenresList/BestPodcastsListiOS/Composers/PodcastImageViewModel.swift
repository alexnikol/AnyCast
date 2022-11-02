// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct PodcastImageViewModel<Image> {
    public let title: String
    public let publisher: String
    public let language: String
    public let type: String
    public let image: Image?
    
    public init(title: String, publisher: String, language: String, type: String, image: Image?) {
        self.title = title
        self.publisher = publisher
        self.language = language
        self.type = type
        self.image = image
    }
}
