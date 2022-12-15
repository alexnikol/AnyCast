// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import SearchContentModule
import PodcastsGenresList

func uniqueTerms() -> [String] {
    ["Any term 1", "Any term 2"]
}

func uniqueGenres() -> [Genre] {
    [Genre(id: 1, name: "Any genre 1"), Genre(id: 2, name: "Any genre 2")]
}

func uniquePodcastSearchResults() -> [PodcastSearchResult] {
    [
        PodcastSearchResult(
            id: UUID().uuidString,
            titleOriginal: "Title",
            publisherOriginal: "Publisher",
            image: anyURL(),
            thumbnail: anyURL()
        ),
        PodcastSearchResult(
            id: UUID().uuidString,
            titleOriginal: "Another Title",
            publisherOriginal: "Another Publisher",
            image: anyURL(),
            thumbnail: anyURL()
        )
    ]
}
