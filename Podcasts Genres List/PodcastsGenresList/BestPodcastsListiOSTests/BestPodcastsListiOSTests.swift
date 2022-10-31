// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList
import BestPodcastsListiOS

class BestPodcastsListiOSTests: XCTestCase {
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: BestPodcastsListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = BestPodcastsListViewController()
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private class LoaderSpy: BestPodcastsLoader {
        
        func load(by genreID: Int, completion: @escaping (BestPodcastsLoader.Result) -> Void) {}
    }
}
