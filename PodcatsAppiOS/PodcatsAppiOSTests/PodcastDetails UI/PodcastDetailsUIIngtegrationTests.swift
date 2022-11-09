// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule
import PodcastsModuleiOS
@testable import Podcats

class PodcastDetailsUIIngtegrationTests: XCTestCase {
    
    func test_loadPodcastDetailsActions_requestPodcastDetails() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedListReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedListReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates a load")
    }
    
    func test_loadPodcastDetailsIndicator_isVisibleWhileLoadingPodcastDetails() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowinLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completePodcastDetailsLoading(at: 0)
        XCTAssertFalse(sut.isShowinLoadingIndicator, "Expected no loading indicator once loading is complete succesfully")
        
        sut.simulateUserInitiatedListReload()
        XCTAssertTrue(sut.isShowinLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completePodcastDetailsLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowinLoadingIndicator, "Expected no loading indicator once loading is completes with error")
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
