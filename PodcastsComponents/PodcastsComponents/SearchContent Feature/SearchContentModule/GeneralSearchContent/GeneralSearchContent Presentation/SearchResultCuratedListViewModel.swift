// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SearchResultCuratedListViewModel {
    public let title: String
    public let description: String
    public let podcasts: [SearchResultPodcast]
    
    public init(title: String, description: String, podcasts: [SearchResultPodcast]) {
        self.title = title
        self.description = description
        self.podcasts = podcasts
    }
}
