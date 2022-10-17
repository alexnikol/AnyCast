// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct BestPodcastsList: Equatable {
    let genreId: Int
    let genreName: String
    let podcasts: [Podcast]
    
    public init(genreId: Int, genreName: String, podcasts: [Podcast]) {
        self.genreId = genreId
        self.genreName = genreName
        self.podcasts = podcasts
    }
}
