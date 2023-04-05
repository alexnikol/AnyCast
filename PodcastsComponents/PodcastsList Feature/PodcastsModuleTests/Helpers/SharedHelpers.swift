// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import PodcastsModule

func makeEpisode(publishDate: Date = Date(), audioLengthInSeconds: Int = 100) -> Episode {
    let publishDateInMiliseconds = Int(publishDate.timeIntervalSince1970) * 1000
    return Episode(
        id: UUID().uuidString,
        title: "Any Episode title",
        description: "<strong>Any Episode description</strong>",
        thumbnail: anyURL(),
        audio: anyURL(),
        audioLengthInSeconds: audioLengthInSeconds,
        containsExplicitContent: false,
        publishDateInMiliseconds: publishDateInMiliseconds
    )
}
