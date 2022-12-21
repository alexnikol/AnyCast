// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule

final class GeneralSearchContentPresentationTests: XCTestCase {
    
    func test_createsViewModel() {
        
    }
    
    // MARK: - Helpers
    
    private func uniqueGeneralSearchContentResult() -> GeneralSearchContentResult {
        let domainItems = uniqueGeneralSearchEpisodes() + uniqueGeneralSearchPodcasts() + uniqueGeneralSearchCuratedLists()
        return GeneralSearchContentResult(result: domainItems)
    }
    
    private func uniqueGeneralSearchEpisodes() -> [GeneralSearchContentResultItem] {
        [
            .episode(
                SearchResultEpisode(
                    id: UUID().uuidString,
                    titleOriginal: "Episode title",
                    descriptionOriginal: "Description",
                    image: anyURL(),
                    thumbnail: anotherURL()
                )
            ),
            .episode(
                SearchResultEpisode(
                    id: UUID().uuidString,
                    titleOriginal: "Another Episode Title",
                    descriptionOriginal: "Another Description",
                    image: anyURL(),
                    thumbnail: anotherURL()
                )
            )
        ]
    }
    
    private func uniqueGeneralSearchPodcasts() -> [GeneralSearchContentResultItem] {
        [
            .podcast(
                SearchResultPodcast(
                    id: UUID().uuidString,
                    titleOriginal: "Podcast Title",
                    publisherOriginal: "Publisher",
                    image: anyURL(),
                    thumbnail: anotherURL()
                )
            ),
            .podcast(
                SearchResultPodcast(
                    id: UUID().uuidString,
                    titleOriginal: "Another Podcast Title",
                    publisherOriginal: "Another Publisher",
                    image: anyURL(),
                    thumbnail: anotherURL()
                )
            )
        ]
    }
    
    private func uniqueGeneralSearchCuratedLists() -> [GeneralSearchContentResultItem] {
        [
            .curatedList(
                SearchResultCuratedList(
                    id: UUID().uuidString,
                    titleOriginal: "Curated Title",
                    descriptionOriginal: "Curated Description",
                    podcasts: [
                        SearchResultPodcast(
                            id: UUID().uuidString,
                            titleOriginal: "Curated Podcast Title",
                            publisherOriginal: "Curated Publisher",
                            image: anyURL(),
                            thumbnail: anotherURL()
                        ),
                        SearchResultPodcast(
                            id: UUID().uuidString,
                            titleOriginal: "Another Curated Podcast title",
                            publisherOriginal: "Another Curated Publisher",
                            image: anyURL(),
                            thumbnail: anotherURL()
                        )
                    ]
                )
            ),
            .curatedList(
                SearchResultCuratedList(
                    id: UUID().uuidString,
                    titleOriginal: "Another Curated Title",
                    descriptionOriginal: "Another Curated Description",
                    podcasts: [
                        SearchResultPodcast(
                            id: UUID().uuidString,
                            titleOriginal: "One More Curated Podcast Title",
                            publisherOriginal: "One More Curated Publisher",
                            image: anyURL(),
                            thumbnail: anotherURL()
                        )
                    ]
                )
            )
        ]
    }
}
