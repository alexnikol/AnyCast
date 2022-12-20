// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SharedComponentsiOSModule
import PodcastsModule
import PodcastsModuleiOS
@testable import Podcats

final class PodcastDetailsUIIngtegrationTests: XCTestCase {
    
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
    
    func test_loadPodcastDetailsCompletion_rendersSuccessfullyLoadedPodcastDetails() {
        let uniquePodcastDetails1 = makeUniquePodcastDetails(episodes: makeUniqueEpisodes())
        let uniquePodcastDetails2 = makeUniquePodcastDetails(episodes: makeUniqueEpisodes())
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        assertThat(sut, isRendering: String())
        assertThat(sut, isRenderingPodcastHeaderWith: nil)
        
        loader.completePodcastDetailsLoading(with: uniquePodcastDetails1, at: 0)
        assertThat(sut, isRendering: uniquePodcastDetails1.episodes)
        assertThat(sut, isRendering: uniquePodcastDetails1.title)
        assertThat(sut, isRenderingPodcastHeaderWith: uniquePodcastDetails1)
        
        sut.simulateUserInitiatedListReload()
        loader.completePodcastDetailsLoading(with: uniquePodcastDetails2, at: 1)
        assertThat(sut, isRendering: uniquePodcastDetails2.episodes)
        assertThat(sut, isRendering: uniquePodcastDetails2.title)
        assertThat(sut, isRenderingPodcastHeaderWith: uniquePodcastDetails2)
    }
    
    func test_loadPodcastDetailsCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let uniquePodcastDetails = makeUniquePodcastDetails(episodes: makeUniqueEpisodes())

        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completePodcastDetailsLoading(with: uniquePodcastDetails, at: 0)
        assertThat(sut, isRendering: uniquePodcastDetails.episodes)
        assertThat(sut, isRendering: uniquePodcastDetails.title)
        assertThat(sut, isRenderingPodcastHeaderWith: uniquePodcastDetails)
        
        sut.simulateUserInitiatedListReload()
        loader.completePodcastDetailsLoadingWithError(at: 1)
        assertThat(sut, isRendering: uniquePodcastDetails.episodes)
        assertThat(sut, isRendering: uniquePodcastDetails.title)
        assertThat(sut, isRenderingPodcastHeaderWith: uniquePodcastDetails)
    }
    
    // MARK: - Podcast Image Tests
    
    func test_podcastImageView_loadsImageURLWhenVisible() {
        let uniquePodcastDetails = makeUniquePodcastDetails(episodes: makeUniqueEpisodes())

        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completePodcastDetailsLoading(with: uniquePodcastDetails, at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulatePodcastDetailsMainImageViewVisible()
        XCTAssertEqual(loader.loadedImageURLs, [uniquePodcastDetails.image], "Expected main image URL request once podcast details view becomes visible")
    }
    
    func test_podcastImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let uniquePodcastDetails = makeUniquePodcastDetails(episodes: makeUniqueEpisodes())

        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completePodcastDetailsLoading(with: uniquePodcastDetails, at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulatePodcastDetailsMainImageViewNotVisible()
        XCTAssertEqual(loader.cancelledImageURLs, [uniquePodcastDetails.image], "Expected one cancelled image URL request once image is not visible anymore")
    }
    
    func test_podcastImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let uniquePodcastDetails = makeUniquePodcastDetails(episodes: makeUniqueEpisodes())

        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completePodcastDetailsLoading(with: uniquePodcastDetails, at: 0)
        
        let headerView1 = sut.simulatePodcastDetailsMainImageViewVisible()

        XCTAssertEqual(headerView1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for view while loading image")
        
        loader.completeImageLoading(at: 0)
        XCTAssertEqual(headerView1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for view once image loading completes successfully")
        
        sut.simulateUserInitiatedListReload()
        loader.completePodcastDetailsLoading(with: uniquePodcastDetails, at: 1)
        
        let headerView2 = sut.simulatePodcastDetailsMainImageViewVisible()
        
        XCTAssertEqual(headerView2?.isShowingImageLoadingIndicator, true, "Expected loading indicator for view while loading image")
        
        loader.completeImageLoading(at: 1)
        XCTAssertEqual(headerView2?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for view once image loading completes successfully")
    }
    
    func test_loadPodcastsDetailsCompletion_dispatchesFromBackgroundToMainThread() {
        let uniquePodcastDetails = makeUniquePodcastDetails(episodes: makeUniqueEpisodes())

        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completePodcastDetailsLoading(with: uniquePodcastDetails, at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
        let uniquePodcastDetails = makeUniquePodcastDetails(episodes: makeUniqueEpisodes())
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completePodcastDetailsLoading(with: uniquePodcastDetails, at: 0)
        sut.simulatePodcastDetailsMainImageViewVisible()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
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
            imageLoader: loader.imageDataPublisher,
            selection: { _, _ in }
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: ListViewController, isRendering episodes: [Episode], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedEpisodesViews() == episodes.count else {
            return XCTFail("Expected \(episodes.count) rendered episodes, got \(sut.numberOfRenderedEpisodesViews()) rendered views instead")
        }
        
        episodes.enumerated().forEach { index, episode in
            assertThat(sut, hasViewConfiguredFor: episode, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: ListViewController,
        isRenderingPodcastHeaderWith model: PodcastDetails?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let podcastHeader = sut.podcastHeader()
        if let model = model {
            let viewModel = PodcastDetailsPresenter.map(model)
            XCTAssertEqual(podcastHeader?.titleText, viewModel.title, file: file, line: line)
            XCTAssertEqual(podcastHeader?.authorText, viewModel.publisher, file: file, line: line)
            XCTAssertNotNil(podcastHeader, file: file, line: line)
        } else {
            XCTAssertNil(podcastHeader, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: ListViewController,
        hasViewConfiguredFor episode: Episode,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let episodeViewModel = EpisodesPresenter().map(episode)
        let view = sut.episodeView(at: index)
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.titleText, episodeViewModel.title, "Wrong title at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.descriptionText, episodeViewModel.description, "Wrong description at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.audioLengthText, episodeViewModel.displayAudioLengthInSeconds, "Wrong audio length at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.publishDateText, episodeViewModel.displayPublishDate, "Wrong publish date at index \(index)", file: file, line: line)
    }
    
    private func assertThat(_ sut: ListViewController, isRendering title: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.title ?? "", title)
    }
    
    private func makeEpisode(
        id: String,
        title: String,
        description: String,
        thumbnail: URL,
        audio: URL,
        audioLengthInSeconds: Int,
        containsExplicitContent: Bool,
        publishDateInMiliseconds: Int
    ) -> Episode {
        Episode(
            id: id,
            title: title,
            description: description,
            thumbnail: thumbnail,
            audio: audio,
            audioLengthInSeconds: audioLengthInSeconds,
            containsExplicitContent: containsExplicitContent,
            publishDateInMiliseconds: publishDateInMiliseconds
        )
    }
    
    private func makeUniqueEpisodes() -> [Episode] {
        let episode1 = makeEpisode(
            id: UUID().uuidString,
            title: "Any Title 1",
            description: "Any Description 1",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: Int.random(in: 1...1000),
            containsExplicitContent: Bool.random(),
            publishDateInMiliseconds: Int.random(in: 1479110302015...1479110402015)
        )
        
        let episode2 = makeEpisode(
            id: UUID().uuidString,
            title: "Any Title 2",
            description: "Any Description 2",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: Int.random(in: 1...1000),
            containsExplicitContent: Bool.random(),
            publishDateInMiliseconds: Int.random(in: 1479110302015...1479110402015)
        )
        return [episode1, episode2]
    }
    
    private func makeUniquePodcastDetails(
        episodes: [Episode]
    ) -> PodcastDetails {
        PodcastDetails(
            id: UUID().uuidString,
            title: "Any Title",
            publisher: "Any Publisher",
            language: "Any Language",
            type: .episodic,
            image: anyURL(),
            episodes: episodes,
            description: "Any Description",
            totalEpisodes: Int.random(in: 1...1000)
        )
    }
}
