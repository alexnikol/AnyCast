// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct LocalPlayingEpisode: PlayingEpisode {
    public var id: String
    public var title: String
    public var thumbnail: URL
    public var audio: URL
    public var publishDateInMiliseconds: Int
    
    public init(id: String, title: String, thumbnail: URL, audio: URL, publishDateInMiliseconds: Int) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.audio = audio
        self.publishDateInMiliseconds = publishDateInMiliseconds
    }
}
