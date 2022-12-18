// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule
import PodcastsGenresList

final class TypeheadSearchContentPresentationTests: XCTestCase {
    
    func test_createsViewModel() {
        let terms = uniqueTerms()
        let genres = uniqueGenres()
        let podcasts = uniquePodcastSearchResults()
        let domainModel = TypeheadSearchContentResult(terms: terms, genres: genres, podcasts: podcasts)
        
        let termsViewModels = TypeheadSearchContentPresenter.map(domainModel.terms)
        let genresViewModels = TypeheadSearchContentPresenter.map(domainModel.genres)
        let podcastsViewModels = TypeheadSearchContentPresenter.map(domainModel.podcasts)
        
        XCTAssertEqual(termsViewModels, terms)
        XCTAssertEqual(genresViewModels, ["Any genre 1", "Any genre 2"])
        assert(
            receivedViewModel: podcastsViewModels[0],
            expectedViewModel: SearchResultPodcastViewModel(
                titleOriginal: "Title",
                publisherOriginal: "Publisher",
                thumbnail: anyURL()
            )
        )
        assert(
            receivedViewModel: podcastsViewModels[1],
            expectedViewModel: SearchResultPodcastViewModel(
                titleOriginal: "Another Title",
                publisherOriginal: "Another Publisher",
                thumbnail: anyURL()
            )
        )
    }
    
    // MARK: - Helpers
    
    private func assert(
        receivedViewModel: SearchResultPodcastViewModel,
        expectedViewModel: SearchResultPodcastViewModel,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(receivedViewModel.titleOriginal, expectedViewModel.titleOriginal, file: file, line: line)
        XCTAssertEqual(receivedViewModel.publisherOriginal, expectedViewModel.publisherOriginal, file: file, line: line)
        XCTAssertEqual(receivedViewModel.thumbnail, expectedViewModel.thumbnail, file: file, line: line)
    }
}
