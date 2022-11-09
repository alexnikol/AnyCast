// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule
import PodcastsModuleiOS
@testable import Podcats

class PodcastDetailsUIIngtegrationTests: XCTestCase {
    
    func test_loadPodcastDetailsActions_requestPodcastsByGenreFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedPodcastsListReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedPodcastsListReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates a load")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        genreID: Int = 1,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ListViewController, loader: BestPodcastsLoaderSpy) {
        let loader = BestPodcastsLoaderSpy()
        let sut = PodcastDetailsUIComposer.podcastDetailsComposedWith(
            genreID: genreID,
            podcastsLoader: loader.podcastsPublisher,
            imageLoader: loader.imageDataPublisher
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
}
