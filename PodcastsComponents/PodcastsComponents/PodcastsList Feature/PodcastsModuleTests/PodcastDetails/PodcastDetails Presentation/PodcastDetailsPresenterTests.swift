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
        XCTAssertEqual(podcastDetailsViewModel.type, String(describing: podcastDetails.type))
        XCTAssertEqual(podcastDetailsViewModel.image, podcastDetails.image)
        XCTAssertEqual(podcastDetailsViewModel.episodes, podcastDetails.episodes)
        XCTAssertEqual(podcastDetailsViewModel.description, podcastDetails.description)
        XCTAssertEqual(podcastDetailsViewModel.totalEpisodes, String(podcastDetails.totalEpisodes))
    }
    
    func test_map_createsEpisodeViewModel() {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let episode1 = makeEpisode(publishDate: now.adding(minutes: -5), audioLengthInSeconds: 62)
        let episode2 = makeEpisode(publishDate: now.adding(days: -3), audioLengthInSeconds: 86420)
        let episodeViewModel1 = PodcastDetailsPresenter.map(episode1, currentDate: now, calendar: calendar, locale: locale)
        let episodeViewModel2 = PodcastDetailsPresenter.map(episode2, currentDate: now, calendar: calendar, locale: locale)
        
        XCTAssertEqual(episodeViewModel1.title, episode1.title)
        XCTAssertEqual(episodeViewModel1.description, episode1.description)
        XCTAssertEqual(episodeViewModel1.thumbnail, episode1.thumbnail)
        XCTAssertEqual(episodeViewModel1.audio, episode1.audio)
        
        XCTAssertEqual(episodeViewModel1.displayPublishDate, "5 minutes ago")
        XCTAssertEqual(episodeViewModel2.displayPublishDate, "3 days ago")
        
        XCTAssertEqual(episodeViewModel1.displayAudioLengthInSeconds, "1min 2secs")
        XCTAssertEqual(episodeViewModel2.displayAudioLengthInSeconds, "24hrs 20secs")
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
    
    private func makeEpisode(publishDate: Date = Date(), audioLengthInSeconds: Int = 100) -> Episode {
        let publishDateInMiliseconds = Int(publishDate.timeIntervalSince1970) * 1000
        return Episode(
            id: UUID().uuidString,
            title: "Any Episode title",
            description: "Any Episode description",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: audioLengthInSeconds,
            containsExplicitContent: false,
            publishDateInMiliseconds: publishDateInMiliseconds
        )
    }
}

private extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}
