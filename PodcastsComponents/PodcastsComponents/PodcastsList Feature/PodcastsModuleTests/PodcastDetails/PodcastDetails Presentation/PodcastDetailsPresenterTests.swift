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
        let episode = makeEpisode()
        let episodeViewModel = PodcastDetailsPresenter.map(episode, currentDate: now, calendar: calendar, locale: locale)
        
        XCTAssertEqual(episodeViewModel.title, episode.title)
        XCTAssertEqual(episodeViewModel.description, episode.description)
        XCTAssertEqual(episodeViewModel.thumbnail, episode.thumbnail)
        XCTAssertEqual(episodeViewModel.audio, episode.audio)
        XCTAssertEqual(episodeViewModel.displayAudioLengthInSeconds, String(episode.audioLengthInSeconds))
    }
    
    func test_map_convertsEpisodePublishDate() {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let episode1 = makeEpisode(publishDate: now.adding(minutes: -5))
        let episode2 = makeEpisode(publishDate: now.adding(days: -3))
        
        let episodeViewModel1 = PodcastDetailsPresenter.map(episode1, currentDate: now, calendar: calendar, locale: locale)
        let episodeViewModel2 = PodcastDetailsPresenter.map(episode2, currentDate: now, calendar: calendar, locale: locale)
        
        XCTAssertEqual(episodeViewModel1.displayPublishDate, "5 minutes ago")
        XCTAssertEqual(episodeViewModel2.displayPublishDate, "3 days ago")
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
    
    private func makeEpisode(publishDate: Date = Date()) -> Episode {
        Episode(
            id: UUID().uuidString,
            title: "Any Episode title",
            description: "Any Episode description",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: 200,
            containsExplicitContent: false,
            publishDateInMiliseconds: Int(publishDate.timeIntervalSince1970)
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
