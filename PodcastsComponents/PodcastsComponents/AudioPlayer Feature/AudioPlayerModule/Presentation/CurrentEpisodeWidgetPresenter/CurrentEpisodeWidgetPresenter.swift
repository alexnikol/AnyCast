// Copyright © 2023 Almost Engineer. All rights reserved.

import Foundation

public final class CurrentEpisodeWidgetPresenter {
    private let calendar: Calendar
    private let locale: Locale
    
    public init(calendar: Calendar = .current, locale: Locale = .current) {
        self.calendar = calendar
        self.locale = locale
    }
    
    public static var continueListeningTitle: String {
        return NSLocalizedString(
            "CONTINUE_LISTENING_WIDGET_TITLE",
             tableName: "WidgetCurrentPlayback",
             bundle: .init(for: Self.self),
             comment: "Title for the no total time state"
        )
    }
    
    public static var widgetTitle: String {
        return NSLocalizedString(
            "WIDGET_TITLE",
             tableName: "WidgetCurrentPlayback",
             bundle: .init(for: Self.self),
             comment: "Title for the widgets store screen"
        )
    }
    
    public static var widgetDescription: String {
        return NSLocalizedString(
            "WIDGET_DESCRIPTION",
             tableName: "WidgetCurrentPlayback",
             bundle: .init(for: Self.self),
             comment: "Description for the widgets store screen"
        )
    }
    
    private lazy var dateFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        var newCalendar = calendar
        newCalendar.locale = locale
        formatter.calendar = newCalendar
        formatter.includesTimeRemainingPhrase = true
        formatter.maximumUnitCount = 1
        formatter.includesApproximationPhrase = true
        return formatter
    }()
    
    public func map(_ playingItem: PlayingItem, thumbnailData: Data) -> CurrentEpisodeWidgetViewModel {
        var timeLabel = Self.continueListeningTitle
       
        for update in playingItem.updates {
            switch update {
            case let .progress(progress):
                switch progress.totalTime {
                case .notDefined:
                    continue
                    
                case let .valueInSeconds(totalTime):
                    let now = Date()
                    let timeRemainingInSeconds = TimeInterval(totalTime) - TimeInterval(progress.currentTimeInSeconds)
                    let delta = Date(timeIntervalSince1970: now.timeIntervalSince1970 - timeRemainingInSeconds)
                    timeLabel = dateFormatter.string(from: delta, to: now) ?? ""
                }
                
            default:
                continue
            }
        }
        
        let model = CurrentEpisodeWidgetViewModel(
            episodeTitle: playingItem.episode.title,
            podcastTitle: playingItem.podcast.title,
            timeLabel: timeLabel,
            thumbnailData: thumbnailData
        )
        return model
    }
}
