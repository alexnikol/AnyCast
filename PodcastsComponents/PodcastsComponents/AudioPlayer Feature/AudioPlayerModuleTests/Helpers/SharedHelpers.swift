// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsModule
import XCTest

extension XCTestCase {
    
    func makeUniqueEpisode(publishDate: Date = Date(), audioLengthInSeconds: Int = 100) -> Episode {
        let publishDateInMiliseconds = Int(publishDate.timeIntervalSince1970) * 1000
        let episode = Episode(
            id: UUID().uuidString,
            title: "Any Episode title",
            description: "<strong>Any Episode description</strong>",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: audioLengthInSeconds,
            containsExplicitContent: false,
            publishDateInMiliseconds: publishDateInMiliseconds
        )
        return episode
    }
    
    func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
}
