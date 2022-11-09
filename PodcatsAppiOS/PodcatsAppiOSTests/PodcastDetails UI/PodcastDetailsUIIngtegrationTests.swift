// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule
import PodcastsModuleiOS
@testable import Podcats

class PodcastDetailsUIIngtegrationTests: XCTestCase {
    
    func test_loadPodcastDetailsActions_requestPodcastDetailsByPodcastIDFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedListReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedListReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates a load")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        podcastID: String = UUID().uuidString,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ListViewController, loader: PodcastDetailsLoaderSpy) {
        let loader = PodcastDetailsLoaderSpy()
        let sut = PodcastDetailsUIComposer.podcastDetailsComposedWith(
            podcastID: podcastID,
            podcastsLoader: loader.podcastDetailsPublisher,
            imageLoader: loader.imageDataPublisher
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
}
