// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

func anyURL() -> URL {
    URL(string: "http://a-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    Data("any data".utf8)
}

func makeEpisode(publishDate: Date = Date(), audioLengthInSeconds: Int = 100) -> Episode {
    let publishDateInMiliseconds = Int(publishDate.timeIntervalSince1970) * 1000
    return Episode(
        id: UUID().uuidString,
        title: "Any Episode title",
        description: "Any Episode description",
        thumbnail: anyURL(),
        audio: anyURL(),
        audioLengthInSeconds: audioLengthInSeconds,
        containsExplicitContent: false,
        publishDateInMiliseconds: publishDateInMiliseconds
    )
}
