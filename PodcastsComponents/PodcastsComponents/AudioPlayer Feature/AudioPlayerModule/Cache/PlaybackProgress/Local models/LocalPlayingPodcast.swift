// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct LocalPlayingPodcast {
    public var id: String
    public var title: String
    public var publisher: String
    
    public init(id: String, title: String, publisher: String) {
        self.id = id
        self.title = title
        self.publisher = publisher
    }
}
