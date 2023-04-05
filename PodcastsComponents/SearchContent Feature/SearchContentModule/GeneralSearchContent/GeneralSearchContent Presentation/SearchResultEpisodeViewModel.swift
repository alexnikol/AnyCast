// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SearchResultEpisodeViewModel {
    public let title: String
    public let description: String
    public let thumbnail: URL
    public let audio: URL
    public let displayAudioLengthInSeconds: String
    public let displayPublishDate: String
    
    public init(title: String,
                description: String,
                thumbnail: URL,
                audio: URL,
                displayAudioLengthInSeconds: String,
                displayPublishDate: String) {
        self.title = title
        self.thumbnail = thumbnail
        self.audio = audio
        self.displayAudioLengthInSeconds = displayAudioLengthInSeconds
        self.displayPublishDate = displayPublishDate
        self.description = description.htmlStripped
    }
}

private extension String{
    var htmlStripped : String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
