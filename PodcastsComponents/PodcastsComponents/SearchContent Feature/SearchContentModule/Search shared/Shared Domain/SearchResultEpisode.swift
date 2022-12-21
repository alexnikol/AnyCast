// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SearchResultEpisode: Equatable {
    public let id: String
    public let titleOriginal: String
    public let descriptionOriginal: String
    public let image: URL
    public let thumbnail: URL
    public let audio: URL
    public let audioLengthInSeconds: Int
    public let containsExplicitContent: Bool
    public let publishDateInMiliseconds: Int
    
    public init(id: String,
                titleOriginal: String,
                descriptionOriginal: String,
                image: URL,
                thumbnail: URL,
                audio: URL,
                audioLengthInSeconds: Int,
                containsExplicitContent: Bool,
                publishDateInMiliseconds: Int) {
        self.id = id
        self.titleOriginal = titleOriginal
        self.descriptionOriginal = descriptionOriginal
        self.image = image
        self.thumbnail = thumbnail
        self.audio = audio
        self.audioLengthInSeconds = audioLengthInSeconds
        self.containsExplicitContent = containsExplicitContent
        self.publishDateInMiliseconds = publishDateInMiliseconds
    }
}
