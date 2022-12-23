// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule
import PodcastsGenresList

final class TypeaheadSearchContentPresentationTests: XCTestCase {
    
    func test_createsViewModel() {
        let terms = uniqueTerms()
        let genres = uniqueGenres()
        let podcasts = uniquePodcastSearchResults()
        let domainModel = TypeaheadSearchContentResult(terms: terms, genres: genres, podcasts: podcasts)
        
        let generalViewModel = TypeaheadSearchContentPresenter.map(domainModel)
        let termsViewModels = domainModel.terms.map(TypeaheadSearchContentPresenter.map)
        let genresViewModels = domainModel.genres.map(TypeaheadSearchContentPresenter.map)
        let podcastsViewModels = domainModel.podcasts.map(TypeaheadSearchContentPresenter.map)
        
        XCTAssertEqual(generalViewModel.terms, domainModel.terms)
        XCTAssertEqual(generalViewModel.podcasts, domainModel.podcasts)
        XCTAssertEqual(generalViewModel.genres, domainModel.genres)
        XCTAssertEqual(termsViewModels, terms)
        XCTAssertEqual(genresViewModels, ["Any genre 1", "Any genre 2"])
        assert(
            receivedViewModel: podcastsViewModels[0],
            expectedViewModel: TypeaheadSearchResultPodcastViewModel(
                titleOriginal: "Title",
                publisherOriginal: "Publisher",
                thumbnail: anotherURL()
            )
        )
        assert(
            receivedViewModel: podcastsViewModels[1],
            expectedViewModel: TypeaheadSearchResultPodcastViewModel(
                titleOriginal: "Another Title",
                publisherOriginal: "Another Publisher",
                thumbnail: anotherURL()
            )
        )
    }
    
    // MARK: - Helpers
    
    private func assert(
        receivedViewModel: TypeaheadSearchResultPodcastViewModel,
        expectedViewModel: TypeaheadSearchResultPodcastViewModel,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(receivedViewModel.titleOriginal, expectedViewModel.titleOriginal, file: file, line: line)
        XCTAssertEqual(receivedViewModel.publisherOriginal, expectedViewModel.publisherOriginal, file: file, line: line)
        XCTAssertEqual(receivedViewModel.thumbnail, expectedViewModel.thumbnail, file: file, line: line)
    }
}
