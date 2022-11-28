// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

public protocol AudioPlayerView {
    func display(viewModel: LargeAudioPlayerViewModel)
}

public final class LargeAudioPlayerPresenter {
    private let calendar: Calendar
    private let locale: Locale
    private let resourceView: AudioPlayerView
    private let podcast: Podcast
    
    public init(resourceView: AudioPlayerView, from podcast: Podcast, calendar: Calendar = .current, locale: Locale = .current) {
        self.resourceView = resourceView
        self.calendar = calendar
        self.locale = locale
        self.podcast = podcast
    }
    
    private lazy var dateFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        var newCalendar = calendar
        newCalendar.locale = locale
        formatter.calendar = newCalendar
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    public func map(playingItem: PlayingItem, from podcast: Podcast) -> LargeAudioPlayerViewModel {
        let description = "\(podcast.title) | \(podcast.publisher)"
        return LargeAudioPlayerViewModel(
            titleLabel: playingItem.episode.title,
            descriptionLabel: description,
            currentTimeLabel: mapCurrentTimeLabel(playingItem.state.currentTimeInSeconds),
            endTimeLabel: mapEndTimeLabel(playingItem.state.totalTime),
            progressTimePercentage: playingItem.state.progressTimePercentage.roundToDecimal(2),
            volumeLevel: playingItem.state.volumeLevel,
            playbackState: PlaybackStateViewModel(playbackState: playingItem.state.playbackState)
        )
    }
    
    public func didReceivePlayerState(with playingItem: PlayingItem) {
        resourceView.display(viewModel: map(playingItem: playingItem, from: podcast))
    }
    
    private func mapCurrentTimeLabel(_ timeInSeconds: Int) -> String {
        return positionalTime(timeInSeconds: TimeInterval(timeInSeconds))
    }
    
    private func mapEndTimeLabel(_ duration: EpisodeDuration) -> String {
        switch duration {
        case .notDefined:
            return "..."
        case let .valueInSeconds(timeInSeconds):
            return positionalTime(timeInSeconds: TimeInterval(timeInSeconds))
        }
    }
    
    private func positionalTime(timeInSeconds: TimeInterval) -> String {
        dateFormatter.allowedUnits = timeInSeconds >= 3600 ?
        [.hour, .minute, .second] :
        [.minute, .second]
        let fullTimeString = dateFormatter.string(from: timeInSeconds) ?? ""
        return fullTimeString.hasPrefix("0") ? String(fullTimeString.dropFirst()) : fullTimeString
    }
}

private extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
