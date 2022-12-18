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

func uniquePodcastSearchResults() -> [SearchResultPodcast] {
    [
        SearchResultPodcast(
            id: UUID().uuidString,
            titleOriginal: "Title",
            publisherOriginal: "Publisher",
            image: anyURL(),
            thumbnail: anyURL()
        ),
        SearchResultPodcast(
            id: UUID().uuidString,
            titleOriginal: "Another Title",
            publisherOriginal: "Another Publisher",
            image: anyURL(),
            thumbnail: anyURL()
        )
    ]
}

func uniqueEpisodeSearchResults() -> [SearchResultEpisode] {
    [
        SearchResultEpisode(
            id: UUID().uuidString,
            titleOriginal: "Title",
            descriptionOriginal: "Description",
            image: anyURL(),
            thumbnail: anyURL()
        ),
        SearchResultEpisode(
            id: UUID().uuidString,
            titleOriginal: "Another Title",
            descriptionOriginal: "Another Description",
            image: anyURL(),
            thumbnail: anyURL()
        )
    ]
}

func uniqueCuratedListsSearchResults() -> [SearchResultCuratedList] {
    [
        SearchResultCuratedList(
            id: UUID().uuidString,
            titleOriginal: "Curated list title",
            descriptionOriginal: "Curated list description",
            podcasts: uniquePodcastSearchResults()
        ),
        SearchResultCuratedList(
            id: UUID().uuidString,
            titleOriginal: "Another Curated list title",
            descriptionOriginal: "Another Curated list description",
            podcasts: uniquePodcastSearchResults()
        )
    ]
}
