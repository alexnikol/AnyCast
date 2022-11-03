// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList
import BestPodcastsListiOS

class BestPodcastsListUIIngtegrationTests: XCTestCase {
    
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
        let uniquePodcasts = makeUniquePodcasts()
        let genreName0 = "Any Genre name"
        let bestPodcastsListResult0 = BestPodcastsList(genreId: 1,
                                                       genreName: genreName0,
                                                       podcasts: [uniquePodcasts[0]])
        
        let genreName1 = "Another Genre name"
        let bestPodcastsListResult1 = BestPodcastsList(genreId: 1,
                                                       genreName: genreName1,
                                                       podcasts: uniquePodcasts)
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        assertThat(sut, isRendering: String())
        
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult0, at: 0)
        assertThat(sut, isRendering: [uniquePodcasts[0]])
        assertThat(sut, isRendering: genreName0)
        
        sut.simulateUserInitiatedPodcastsListReload()
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult1, at: 1)
        assertThat(sut, isRendering: uniquePodcasts)
        assertThat(sut, isRendering: genreName1)
    }
    
    func test_loadPodcastsCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let podcast = makeUniquePodcasts()[0]
        let genreName = "Any Genre name"
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeBestPodcastsLoading(with: .init(genreId: 1, genreName: genreName, podcasts: [podcast]), at: 0)
        assertThat(sut, isRendering: [podcast])
        assertThat(sut, isRendering: genreName)
        
        sut.simulateUserInitiatedPodcastsListReload()
        loader.completeBestPodcastsLoadingWithError(at: 1)
        assertThat(sut, isRendering: genreName)
    }
    
    func test_podcastImageView_loadsImageURLWhenVisible() {
        let podcasts = makeUniquePodcasts()
        let bestPodcastsListResult = BestPodcastsList(genreId: 1,
                                                      genreName: "Any Genre Name",
                                                      podcasts: [podcasts[0], podcasts[1]])
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult, at: 0)
        
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulatePodcastImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [podcasts[0].image], "Expected first image URL request once first view becomes visible")
    }
    
    func test_podcastImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let podcasts = makeUniquePodcasts()
        let bestPodcastsListResult = BestPodcastsList(genreId: 1,
                                                      genreName: "Any Genre Name",
                                                      podcasts: [podcasts[0], podcasts[1]])
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult, at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulatePodcastImageNotViewVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [podcasts[0].image], "Expected one cancelled image URL request once first image is not visible anymore")
        
        sut.simulatePodcastImageNotViewVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [podcasts[0].image, podcasts[1].image], "Expected one cancelled image URL request once first image is not visible anymore")
    }
    
    func test_podcastImageView_preloadsImageURLWhenNearVisible() {
        let podcasts = makeUniquePodcasts()
        let bestPodcastsListResult = BestPodcastsList(genreId: 1,
                                                      genreName: "Any Genre Name",
                                                      podcasts: [podcasts[0], podcasts[1]])
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult, at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")
        
        sut.simulatePodcastImageViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [podcasts[0].image], "Expected first image URL request once first image is near visible")
        
        sut.simulatePodcastImageViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [podcasts[0].image, podcasts[1].image], "Expected second image URL request once second image is near visible")
    }
    
    func test_podcastImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
        let podcasts = makeUniquePodcasts()
        let bestPodcastsListResult = BestPodcastsList(genreId: 1,
                                                      genreName: "Any Genre Name",
                                                      podcasts: [podcasts[0], podcasts[1]])
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult, at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not near visible")
        
        sut.simulatePodcastImageViewNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [podcasts[0].image], "Expected first cancelled image URL request once first image is not near visible anymore")
        
        sut.simulatePodcastImageViewNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [podcasts[0].image, podcasts[1].image], "Expected second cancelled image URL request once second image is not near visible anymore")
    }
    
    func test_podcastImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let podcasts = makeUniquePodcasts()
        let bestPodcastsListResult = BestPodcastsList(genreId: 1,
                                                      genreName: "Any Genre Name",
                                                      podcasts: podcasts)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult, at: 0)
        
        let view0 = sut.simulatePodcastImageViewVisible(at: 0)
        let view1 = sut.simulatePodcastImageViewVisible(at: 1)

        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")
        
        loader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")
        
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")
    }
    
    func test_loadPodcastsCompletion_dispatchesFromBackgroundToMainThread() {
        
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeBestPodcastsLoading(with: .init(genreId: 1, genreName: "Any Genre Name", podcasts: []), at: 0)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
        let podcast0 = makeUniquePodcasts()[0]
        let bestPodcastsListResult = BestPodcastsList(genreId: 1,
                                                      genreName: "Any Genre Name",
                                                      podcasts: [podcast0])
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeBestPodcastsLoading(with: bestPodcastsListResult, at: 0)
        _ = sut.simulatePodcastImageViewVisible(at: 0)
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: self.anyImageData(), at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        genreID: Int = 1,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ListViewController, loader: BestPodcastsLoaderSpy) {
        let loader = BestPodcastsLoaderSpy()
        let sut = BestPodcastsUIComposer.bestPodcastComposed(genreID: genreID, podcastsLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: ListViewController, isRendering podcasts: [Podcast], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedPodcastsViews() == podcasts.count else {
            return XCTFail("Expected \(podcasts.count) rendered podcast, got \(sut.numberOfRenderedPodcastsViews()) rendered views instead")
        }
        
        podcasts.enumerated().forEach { index, podcast in
            assertThat(sut, hasViewConfiguredFor: podcast, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: ListViewController,
        hasViewConfiguredFor podcast: Podcast,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let view = sut.podcastView(at: index) as? PodcastCell
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.titleText, podcast.title, "Wrong name at index \(index)", file: file, line: line)
    }
    
    private func assertThat(_ sut: ListViewController, isRendering title: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.title ?? "", title)
    }
    
    private func makePodcast(
        id: String = UUID().uuidString,
        title: String,
        publisher: String = "Any Publisher",
        language: String = "Any Language",
        type: PodcastType = .serial,
        image: URL
    ) -> Podcast {
        Podcast(id: id, title: title, publisher: publisher, language: language, type: type, image: image)
    }
    
    private func makeUniquePodcasts() -> [Podcast] {
        let podcast0 = makePodcast(title: "any name", publisher: "any publisher", language: "any language", type: .serial, image: anyURL())
        let podcast1 = makePodcast(title: "another name", publisher: "another publisher", language: "another language", type: .serial, image: anyURL())
        let podcast2 = makePodcast(title: "long name", publisher: "long publisher", language: "long language", type: .episodic, image: anyURL())
        let podcast3 = makePodcast(title: "some name", publisher: "some publisher", language: "some language", type: .episodic, image: anyURL())
        return [podcast0, podcast1, podcast2, podcast3]
    }
        
    private func makeBestPodcastsList(genreId: Int = 1, genreName: String = "Any genre name", podcasts: [Podcast]) -> BestPodcastsList {
        BestPodcastsList(genreId: genreId, genreName: genreName, podcasts: podcasts)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    private func anyImageData() -> Data {
        return Data()
    }
}
