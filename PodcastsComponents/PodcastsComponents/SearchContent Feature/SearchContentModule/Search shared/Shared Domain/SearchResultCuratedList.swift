// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SearchResultCuratedList: Equatable {
    public let id: String
    public let titleOriginal: String
    public let descriptionOriginal: String
    public let podcasts: [SearchResultPodcast]
    
    public init(id: String, titleOriginal: String, descriptionOriginal: String, podcasts: [SearchResultPodcast]) {
        self.id = id
        self.titleOriginal = titleOriginal
        self.descriptionOriginal = descriptionOriginal
        self.podcasts = podcasts
    }
}
