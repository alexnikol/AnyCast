// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import SearchContentModule

struct GeneralSearchResult {
    let episodes: [SearchResultEpisode]
    let podcasts: [SearchResultPodcast]
    let curatedLists: [SearchResultCuratedList]
}

func makeGeneralSearchContentResult() -> (models: GeneralSearchResult, renderModels: GeneralSearchContentResult) {
    let episodes = makeSearchEpisodes()
    let episodesModels = episodes.map(GeneralSearchContentResultItem.episode)
    let podcasts = makePodcasts()
    let podcastsModels = podcasts.map(GeneralSearchContentResultItem.podcast)
    let curatedLists = makeCuratedLists()
    let curatedListModels = curatedLists.map(GeneralSearchContentResultItem.curatedList)
    let result = GeneralSearchContentResult(result: curatedListModels + podcastsModels + episodesModels)
    return (GeneralSearchResult(episodes: episodes, podcasts: podcasts, curatedLists: curatedLists), result)
}

func makeSearchEpisodes() -> [SearchResultEpisode] {
    [
        makeSearchEpisode(),
        makeSearchEpisode()
    ]
}

func makePodcasts() -> [SearchResultPodcast] {
    [
        makeSearchPodcast(title: "Any Podcast title", publisher: "Any Publisher title"),
        makeSearchPodcast(title: "Another Podcast title", publisher: "Another Podcast title")
    ]
}

func makeCuratedLists() -> [SearchResultCuratedList] {
    [
        makeSearchCuratedList(
            title: "Curated list 1",
            description: "Description 1",
            podcasts: makePodcasts()
        ),
        makeSearchCuratedList(
            title: "Curated list 2",
            description: "Description 2",
            podcasts: makePodcasts()
        )
    ]
}

func makeSearchEpisode() -> SearchResultEpisode {
    SearchResultEpisode(
        id: UUID().uuidString,
        title: "Any Episode Title",
        description: "Any Episode Description",
        thumbnail: anyURL(),
        audio: anyURL(),
        audioLengthInSeconds: Int.random(in: 1...1000),
        containsExplicitContent: Bool.random(),
        publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853),
        podcast: makeSearchPodcast(title: "Any title", publisher: "Any publisher")
    )
}

func makeSearchPodcast(title: String, publisher: String) -> SearchResultPodcast {
    SearchResultPodcast(
        id: UUID().uuidString,
        titleOriginal: title,
        publisherOriginal: publisher,
        image: anyURL(),
        thumbnail: anotherURL()
    )
}

func makeSearchCuratedList(title: String, description: String, podcasts: [SearchResultPodcast]) -> SearchResultCuratedList {
    SearchResultCuratedList(
        id: UUID().uuidString,
        titleOriginal: title,
        descriptionOriginal: description,
        podcasts: podcasts
    )
}
