// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import HTTPClient
import PodcastsGenresList
import PodcastsGenresListiOS
import PodcastsModuleiOS
import AudioPlayerModuleiOS
@testable import Podcats

class PodcatsAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteGenresWhenCustomerHasConnectivityAndEmptyCache() {
        let genres = launch(store: InMemoryGenresStore.empty, httpClient: HTTPClientStub.online(response))
        
        XCTAssertEqual(genres.numberOfRenderedGenresViews(), 2)
    }
    
    func test_onLaunch_displaysNoGenresWhenCustomersHasNoConnectivityAndEmptyCache() {
        let genres = launch(store: InMemoryGenresStore.empty, httpClient: HTTPClientStub.offline)
        
        XCTAssertEqual(genres.numberOfRenderedGenresViews(), 0)
    }
    
    func test_onLaunch_displaysCachedGenresWhenCustomerHasConnectivityAndNonExpiredCache() {
        let sharedStore = InMemoryGenresStore.withNonExpiredFeedCache
        let genres = launch(store: sharedStore, httpClient: HTTPClientStub.offline)
        
        XCTAssertNotNil(sharedStore.cache)
        XCTAssertEqual(genres.numberOfRenderedGenresViews(), 1)
    }
    
    func test_onEnteringBackground_deletesExpiredGenresCache() {
        let store = InMemoryGenresStore.withExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNil(store.cache, "Expected to delete expired cache")
    }
    
    func test_onEnteringBackground_keepsNonExpiredFeedCache() {
        let store = InMemoryGenresStore.withNonExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNotNil(store.cache, "Expected to keep non expired cache")
    }
    
    func test_onPodcastGenreSelection_displaysBestPodcasts() {
        let bestPodcasts = showBestPodcasts()
        
        XCTAssertEqual(bestPodcasts.numberOfRenderedPodcastsViews(), 2)
    }
    
    func test_onPodcastSelection_displaysPodcastDetails() {
        let bestPodcasts = showBestPodcasts()
        let podcastDetails = showPodcastDetails(from: bestPodcasts)

        XCTAssertEqual(podcastDetails.numberOfRenderedEpisodesViews(), 1)
    }
    
    func test_onEpisodeSelection_displaysAudioPlayer() {
        let bestPodcasts = showBestPodcasts()
        let podcastDetails = showPodcastDetails(from: bestPodcasts)
        let audioPlayer = showAudioPlayer(from: podcastDetails)
        audioPlayer.loadView()
        
        XCTAssertEqual(audioPlayer.episodeTitleText(), "Episode title")
        XCTAssertEqual(audioPlayer.episodeDescriptionText(), "Podcast  title")
        
    }
    
    // MARK: - Helpers
    
    private func launch(
        store: GenresStore,
        httpClient: HTTPClient,
        file: StaticString = #file,
        line: UInt = #line
    ) -> GenresListViewController {
        let sut = SceneDelegate(httpClient: httpClient, genresStore: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let tabBar = sut.window?.rootViewController as? RootTabBarController
        let nav = tabBar?.viewControllers?.first as? UINavigationController
        let genres = nav?.topViewController as! GenresListViewController
        return genres
    }
    
    private func enterBackground(with store: InMemoryGenresStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, genresStore: store)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func showBestPodcasts() -> ListViewController {
        let genres = launch(store: InMemoryGenresStore.empty, httpClient: HTTPClientStub.online(response))
        
        genres.simulateTapOnGenre(at: 0)
        RunLoop.current.run(until: Date())
        
        let nav = genres.navigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func showPodcastDetails(from bestPodcastsListScreen: ListViewController) -> ListViewController {
        bestPodcastsListScreen.simulateTapOnPodcast(at: 0)
        RunLoop.current.run(until: Date())
        
        let nav = bestPodcastsListScreen.navigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func showAudioPlayer(from podcastDetailsScreen: ListViewController) -> LargeAudioPlayerViewController {
        podcastDetailsScreen.simulateTapOnEpisode(at: 0)
        RunLoop.current.run(until: Date())
        
        let nav = podcastDetailsScreen.navigationController
        return nav?.presentedViewController as! LargeAudioPlayerViewController
    }
    
    private func makeData(for url: URL) -> Data {
        let baseURL = "https://listen-api-test.listennotes.com"
        switch url.absoluteString {
        case "\(baseURL)/api/v2/genres":
            return makeGenresData()
            
        case "\(baseURL)/api/v2/best_podcasts?genre_id=1":
            return makeBestPodcastsData()
            
        case "\(baseURL)/api/v2/podcasts/unique_podcast_id":
            return makePodcastDetailsData()
            
        default:
            return Data()
        }
    }
    
    private func makeGenresData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["genres": [
            ["id": 1, "name": "Any Genre 1"],
            ["id": 2, "name": "Any Genre 2"]
        ]])
    }
    
    private func makeBestPodcastsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            "id": 1,
            "name": "Any Genre name",
            "podcasts": [
                [
                    "id": "unique_podcast_id",
                    "title": "Any Podcast name",
                    "publisher": "Any Publisher name",
                    "type": "episodic",
                    "image": "https://any-url.com/image1",
                    "language": "English"
                ],
                [
                    "id": UUID().uuidString,
                    "title": "Another Podcast name",
                    "publisher": "Another Publisher name",
                    "type": "serial",
                    "image": "https://any-url.com/image1",
                    "language": "Ukranian"
                ]
            ]])
    }
    
    private func makePodcastDetailsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            "id": UUID().uuidString,
            "title": "Any Podcast Details Title",
            "publisher": "Any Publisher",
            "language": "Any Language",
            "type": "serial",
            "image": "https://any-url.com/image",
            "episodes": [
                [
                    "id": UUID().uuidString,
                    "title": "Any Episode Title",
                    "description": "Any Description",
                    "thumbnail": "https://any-url.com/thumbnail",
                    "audio": "https://any-url.com/audio",
                    "audio_length_sec": 300,
                    "explicit_content": true,
                    "pub_date_ms": 12312312332
                ]
            ],
            "description": "Any Description",
            "total_episodes": 200
        ])
    }
}
