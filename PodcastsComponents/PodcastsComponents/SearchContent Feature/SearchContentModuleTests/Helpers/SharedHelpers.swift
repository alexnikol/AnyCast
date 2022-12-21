// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import PodcastsModule
import PodcastsGenresList
import SearchContentModule

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
            thumbnail: anotherURL()
        ),
        SearchResultPodcast(
            id: UUID().uuidString,
            titleOriginal: "Another Title",
            publisherOriginal: "Another Publisher",
            image: anyURL(),
            thumbnail: anotherURL()
        )
    ]
}

func uniqueEpisodeSearchResults() -> [Episode] {
    [
        Episode(
            id: UUID().uuidString,
            title: "Title",
            description: "Description",
            thumbnail: anotherURL(),
            audio: anyURL(),
            audioLengthInSeconds: 200,
            containsExplicitContent: true,
            publishDateInMiliseconds: Int.random(in: 1479110302015...1479110402015)
        ),
        Episode(
            id: UUID().uuidString,
            title: "Another Title",
            description: "Another Description",
            thumbnail: anotherURL(),
            audio: anotherURL(),
            audioLengthInSeconds: 320,
            containsExplicitContent: false,
            publishDateInMiliseconds: Int.random(in: 1479110302015...1479110402015)
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
