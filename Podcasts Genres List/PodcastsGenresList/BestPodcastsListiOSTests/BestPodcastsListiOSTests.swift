// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList
import BestPodcastsListiOS

class BestPodcastsListiOSTests: XCTestCase {
    
    func test_loadPodcastsActions_requestPodcastsByGenreFromLoader() {
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
    ) -> (sut: BestPodcastsListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = BestPodcastsListViewController(genreID: genreID, loader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private class LoaderSpy: BestPodcastsLoader {
        
        private var completions: [(BestPodcastsLoader.Result) -> Void] = []
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(by genreID: Int, completion: @escaping (BestPodcastsLoader.Result) -> Void) {
            completions.append(completion)
        }
    }
}

private extension BestPodcastsListViewController {
    func simulateUserInitiatedPodcastsListReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        self.allTargets.forEach { target in
                actions(forTarget: target, forControlEvent: .valueChanged)?
                .forEach { (target as NSObject).perform(Selector($0)) }
        }
    }
}
