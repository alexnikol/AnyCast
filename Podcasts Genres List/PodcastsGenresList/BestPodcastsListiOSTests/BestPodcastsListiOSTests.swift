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
    
    func test_loadPodcastsIndicator_isVisibleWhileLoadingPodcasts() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowinLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeBestPodcastsLoading(at: 0)
        XCTAssertFalse(sut.isShowinLoadingIndicator, "Expected no loading indicator once loading is complete succesfully")
        
        sut.simulateUserInitiatedPodcastsListReload()
        XCTAssertTrue(sut.isShowinLoadingIndicator, "Expected loading indicator once user initiates a reload")
                
        loader.completeBestPodcastsLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowinLoadingIndicator, "Expected no loading indicator once loading is completes with error")
    }
    
    func test_loadPodcastsCompletion_rendersSuccessfullyLoadedPodcastsData() {
        let podcast0 = makePodcast(title: "any name", image: anyURL())
        let podcast1 = makePodcast(title: "another name", image: anyURL())
        let podcast2 = makePodcast(title: "long name", image: anyURL())
        let podcast3 = makePodcast(title: "some name", image: anyURL())
        let genreName0 = "Any Genre name"
        let bestPodcastsListResult0 = BestPodcastsList(genreId: 1,
                                                       genreName: genreName0,
                                                       podcasts: [podcast0])
        
        let genreName1 = "Another Genre name"
        let bestPodcastsListResult1 = BestPodcastsList(genreId: 1,
                                                       genreName: genreName1,
                                                       podcasts: [podcast0, podcast1, podcast2, podcast3])
                
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        assertThat(sut, isRendering: String())
        
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult0, at: 0)
        assertThat(sut, isRendering: [podcast0])
        assertThat(sut, isRendering: genreName0)
        
        sut.simulateUserInitiatedPodcastsListReload()
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult1, at: 1)
        assertThat(sut, isRendering: [podcast0, podcast1, podcast2, podcast3])
        assertThat(sut, isRendering: genreName1)
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
    
    private func assertThat(_ sut: BestPodcastsListViewController, isRendering podcasts: [Podcast], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedGenresViews() == podcasts.count else {
            return XCTFail("Expected \(podcasts.count) rendered genres, got \(sut.numberOfRenderedGenresViews()) rendered views instead")
        }
        
        podcasts.enumerated().forEach { index, podcast in
            assertThat(sut, hasViewConfiguredFor: podcast, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: BestPodcastsListViewController,
        hasViewConfiguredFor podcast: Podcast,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let view = sut.podcastView(at: index) as? PodcastCell
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.titleText, podcast.title, "Wrong name at index \(index)", file: file, line: line)
    }
    
    private func assertThat(_ sut: BestPodcastsListViewController, isRendering title: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.title ?? "", title)
    }
    
    private func makePodcast(title: String, image: URL) -> Podcast {
        Podcast(id: UUID().uuidString, title: title, image: image)
    }
    
    private func makeBestPodcastsList(genreId: Int = 1, genreName: String = "Any genre name", podcasts: [Podcast]) -> BestPodcastsList {
        BestPodcastsList(genreId: genreId, genreName: genreName, podcasts: podcasts)
    }
    
    func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    private class LoaderSpy: BestPodcastsLoader {
        
        private var bestPodcastRequests: [(BestPodcastsLoader.Result) -> Void] = []
        
        var loadCallCount: Int {
            return bestPodcastRequests.count
        }
        
        func load(by genreID: Int, completion: @escaping (BestPodcastsLoader.Result) -> Void) {
            bestPodcastRequests.append(completion)
        }
        
        func completeBestPodcastsLoading(with bestPodcastsList: BestPodcastsList = .init(genreId: 1, genreName: "any genre name", podcasts: []), at index: Int) {
            bestPodcastRequests[index](.success(bestPodcastsList))
        }
        
        func completeBestPodcastsLoadingWithError(at index: Int) {
            let error = NSError(domain: "any error", code: 0)
            bestPodcastRequests[index](.failure(error))
        }
    }
}

private extension BestPodcastsListViewController {
    func simulateUserInitiatedPodcastsListReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowinLoadingIndicator: Bool {
        return tableView.refreshControl?.isRefreshing ?? false
    }
    
    private var podcastsSection: Int {
        return 0
    }
    
    func numberOfRenderedGenresViews() -> Int {
        return tableView.numberOfRows(inSection: podcastsSection)
    }
    
    func podcastView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: podcastsSection)
        return ds?.tableView(tableView, cellForRowAt: index)
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

private extension PodcastCell {
    var titleText: String? {
        return titleLabel.text
    }
}
