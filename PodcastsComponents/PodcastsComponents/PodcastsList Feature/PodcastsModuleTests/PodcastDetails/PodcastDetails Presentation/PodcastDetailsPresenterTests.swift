// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import PodcastsModule

class PodcastDetailsPresenterTests: XCTestCase {
    
    func test_map_createsPodcastDetailsViewModel() {
        let episode = makeEpisode()
        let podcastDetails = makePodcastDetail(with: [episode])
        let podcastDetailsViewModel = PodcastDetailsPresenter.map(podcastDetails)
        
        XCTAssertEqual(podcastDetailsViewModel.title, podcastDetails.title)
        XCTAssertEqual(podcastDetailsViewModel.publisher, podcastDetails.publisher)
        XCTAssertEqual(podcastDetailsViewModel.language, podcastDetails.language)
        XCTAssertEqual(podcastDetailsViewModel.type, String(describing: podcastDetails.type))
        XCTAssertEqual(podcastDetailsViewModel.image, podcastDetails.image)
        XCTAssertEqual(podcastDetailsViewModel.episodes, podcastDetails.episodes)
        XCTAssertEqual(podcastDetailsViewModel.description, podcastDetails.description)
        XCTAssertEqual(podcastDetailsViewModel.totalEpisodes, String(podcastDetails.totalEpisodes))
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
}
