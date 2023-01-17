// Copyright © 2023 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import AudioPlayerModule

final class CurrentEpisodeWidgetPresenterTests: XCTestCase, LocalizationTestCase {
    
    func test_createsViewModel() {
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 10, totalTime: .valueInSeconds(210), playbackSpeed: .x1)
        let imageData = Data("imageData".utf8)
        
        let sut = makeSUT()
        let viewModel = sut.map(playingItem, thumbnailData: imageData)
        
        XCTAssertEqual(viewModel.episodeTitle, "Any Episode title")
        XCTAssertEqual(viewModel.podcastTitle, "Any Podcast Title")
        XCTAssertEqual(viewModel.thumbnailData, imageData)
    }
    
    func test_createsViewModelTimeRemainig() {
        let playingItem1 = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 10, totalTime: .valueInSeconds(210), playbackSpeed: .x1)
        let playingItem2 = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined, playbackSpeed: .x1)
        let imageData = Data("imageData".utf8)
        
        let sut = makeSUT()
        let viewModel1 = sut.map(playingItem1, thumbnailData: imageData)
        let viewModel2 = sut.map(playingItem2, thumbnailData: imageData)
        
        XCTAssertEqual(viewModel1.timeLabel, "About 3 min remaining")
        XCTAssertEqual(viewModel2.timeLabel, localized("CONTINUE_LISTENING_WIDGET_TITLE", bundle: bundle, table: tableName))
    }
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        checkForMissingLocalizationInAllSupportedLanguages(bundle: bundle, table: tableName)
    }
    
    func test_localizedStrings_presenterHasLocalizedWidgetsPresentationTitles() {
        XCTAssertEqual(CurrentEpisodeWidgetPresenter.widgetTitle, localized("WIDGET_TITLE", bundle: bundle, table: tableName))
        XCTAssertEqual(CurrentEpisodeWidgetPresenter.widgetDescription, localized("WIDGET_DESCRIPTION", bundle: bundle, table: tableName))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> CurrentEpisodeWidgetPresenter {
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let presenter = CurrentEpisodeWidgetPresenter(calendar: calendar, locale: locale)
        trackForMemoryLeaks(presenter)
        return presenter
    }
    
    private var tableName: String {
        "WidgetCurrentPlayback"
    }
    
    private var bundle: Bundle {
        Bundle(for: CurrentEpisodeWidgetPresenter.self)
    }
}
