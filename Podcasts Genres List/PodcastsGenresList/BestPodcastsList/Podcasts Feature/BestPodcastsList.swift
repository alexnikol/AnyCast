// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct BestPodcastsList: Equatable {
    let genreId: String
    let genreName: String
    let podcasts: [Podcast]
    
    public init(genreId: String, genreName: String, podcasts: [Podcast]) {
        self.genreId = genreId
        self.genreName = genreName
        self.podcasts = podcasts
    }
}
