// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

final class EpisodesPresenterTests: XCTestCase {
        
    func test_map_createsEpisodeViewModel() {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let episodesPresenter = EpisodesPresenter(calendar: calendar, locale: locale)
        
        let episode1 = makeEpisode(publishDate: now.adding(minutes: -5), audioLengthInSeconds: 62)
        let episode2 = makeEpisode(publishDate: now.adding(days: -3), audioLengthInSeconds: 86420)
        let episodeViewModel1 = episodesPresenter.map(episode1, currentDate: now)
        let episodeViewModel2 = episodesPresenter.map(episode2, currentDate: now)
        
        XCTAssertEqual(episodeViewModel1.title, episode1.title)
        XCTAssertEqual(episodeViewModel1.thumbnail, episode1.thumbnail)
        XCTAssertEqual(episodeViewModel1.audio, episode1.audio)
        
        XCTAssertEqual(episodeViewModel1.displayPublishDate, "5 minutes ago")
        XCTAssertEqual(episodeViewModel2.displayPublishDate, "3 days ago")
        
        XCTAssertEqual(episodeViewModel1.displayAudioLengthInSeconds, "1min 2sec")
        XCTAssertEqual(episodeViewModel2.displayAudioLengthInSeconds, "24hr 20sec")
        
        XCTAssertEqual(episodeViewModel1.description, "Any Episode description")
    }
}
