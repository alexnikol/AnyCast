// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SearchResultEpisode: Equatable {
    public let id: String
    public let title: String
    public let description: String
    public let thumbnail: URL
    public let audio: URL
    public let audioLengthInSeconds: Int
    public let containsExplicitContent: Bool
    public let publishDateInMiliseconds: Int
    public let podcast: SearchResultPodcast
    
    public init(id: String,
                title: String,
                description: String,
                thumbnail: URL,
                audio: URL,
                audioLengthInSeconds: Int,
                containsExplicitContent: Bool,
                publishDateInMiliseconds: Int,
                podcast: SearchResultPodcast) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnail = thumbnail
        self.audio = audio
        self.audioLengthInSeconds = audioLengthInSeconds
        self.containsExplicitContent = containsExplicitContent
        self.publishDateInMiliseconds = publishDateInMiliseconds
        self.podcast = podcast
    }
}
