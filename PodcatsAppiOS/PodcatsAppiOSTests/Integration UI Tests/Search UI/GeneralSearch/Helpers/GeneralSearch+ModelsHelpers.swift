// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import PodcastsModule
import SearchContentModule

typealias ResultModels = (episodes: [Episode],
                          podcasts: [SearchResultPodcast],
                          curatedLists: [SearchResultCuratedList])

func makeGeneralSearchContentResult() -> (models: ResultModels, renderModels: GeneralSearchContentResult) {
    let episodes = makeEpisodes()
    let episodesModels = episodes.map(GeneralSearchContentResultItem.episode)
    let podcasts = makePodcasts()
    let podcastsModels = podcasts.map(GeneralSearchContentResultItem.podcast)
    let curatedLists = makeCuratedLists()
    let curatedListModels = curatedLists.map(GeneralSearchContentResultItem.curatedList)
    let result = GeneralSearchContentResult(result: curatedListModels + podcastsModels + episodesModels)
    return ((episodes, podcasts, curatedLists), result)
}

func makeEpisodes() -> [Episode] {
    [
        makeEpisode(),
        makeEpisode()
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
