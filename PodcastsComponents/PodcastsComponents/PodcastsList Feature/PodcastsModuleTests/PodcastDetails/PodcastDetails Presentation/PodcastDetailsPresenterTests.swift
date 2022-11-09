// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class PodcastDetailsPresenterTests: XCTestCase {
    
    func test_map_createsPodcastDetailsViewModel() {
        let episode = makeEpisode()
        let podcastDetails = makePodcastDetail(with: [episode])
        let podcastDetailsViewModel = PodcastDetailsPresenter.map(podcastDetails)
        
        XCTAssertEqual(podcastDetailsViewModel.title, podcastDetails.title)
        XCTAssertEqual(podcastDetailsViewModel.publisher, podcastDetails.publisher)
        XCTAssertEqual(podcastDetailsViewModel.language, podcastDetails.language)
        XCTAssertEqual(podcastDetailsViewModel.type, "")
        XCTAssertEqual(podcastDetailsViewModel.image, podcastDetails.image)
        XCTAssertEqual(podcastDetailsViewModel.episodes, podcastDetails.episodes)
        XCTAssertEqual(podcastDetailsViewModel.description, podcastDetails.description)
        XCTAssertEqual(podcastDetailsViewModel.totalEpisodes, String(podcastDetails.totalEpisodes))
    }
    
    func test_map_createsEpisodeViewModel() {
        let episode = makeEpisode()
        let episodeViewModel = PodcastDetailsPresenter.map(episode)
        
        XCTAssertEqual(episodeViewModel.title, episode.title)
        XCTAssertEqual(episodeViewModel.description, episode.description)
        XCTAssertEqual(episodeViewModel.thumbnail, episode.thumbnail)
        XCTAssertEqual(episodeViewModel.audio, episode.audio)
        XCTAssertEqual(episodeViewModel.displayAudioLengthInSeconds, String(episode.audioLengthInSeconds))
    }
    
    // MARK: - Helpers
    
    private func makePodcastDetail(with episodes: [Episode]) -> PodcastDetails {
        PodcastDetails(
            id: UUID().uuidString,
            title: "Any Title",
            publisher: "Any Publisher",
            language: "Any Language",
            type: .serial,
            image: anyURL(),
            episodes: episodes,
            description: "Any Description",
            totalEpisodes: 100
        )
    }
    
    private func makeEpisode() -> Episode {
        Episode(
            id: UUID().uuidString,
            title: "Any Episode title",
            description: "Any Episode description",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: 200,
            containsExplicitContent: false,
            publishDateInMiliseconds: 1479110402015
        )
    }
}
