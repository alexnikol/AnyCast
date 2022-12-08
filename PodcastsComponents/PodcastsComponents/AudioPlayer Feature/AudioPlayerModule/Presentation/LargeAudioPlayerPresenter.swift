// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol AudioPlayerView {
    func display(viewModel: LargeAudioPlayerViewModel)
    func displaySpeedPlaybackSelection(with list: [PlaybackSpeed])
    func diplayFuturePrepareForSeekProgress(with progress: ProgressViewModel)
}

public final class LargeAudioPlayerPresenter {
    private let calendar: Calendar
    private let locale: Locale
    private let resourceView: AudioPlayerView
    private let playbackSpeedList: [PlaybackSpeed]
    private var selectedSpeed: PlaybackSpeed?
    
    public init(resourceView: AudioPlayerView, calendar: Calendar = .current, locale: Locale = .current, playbackSpeedList: [PlaybackSpeed] = PlaybackSpeed.allCases) {
        self.resourceView = resourceView
        self.calendar = calendar
        self.locale = locale
        self.playbackSpeedList = playbackSpeedList
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
        
    public func map(playingItem: PlayingItem) -> LargeAudioPlayerViewModel {
        let description = "\(playingItem.podcast.title) | \(playingItem.podcast.publisher)"
        return LargeAudioPlayerViewModel(
            titleLabel: playingItem.episode.title,
            descriptionLabel: description,
            updates: playingItem.updates.map(map(_:))
        )
    }
    
    private func map(_ stateModel: PlayingItem.State) -> LargeAudioPlayerViewModel.UpdatesViewModel {
        switch stateModel {
        case let .playback(state):
            return .playback(PlaybackStateViewModel(playbackState: state))
            
        case let .volumeLevel(model):
            return .volumeLevel(model)
            
        case let .progress(model):
            return .progress(mapProgress(model: model))
            
        case let .speed(model):
            selectedSpeed = model
            return .speed(SpeedPlaybackItemViewModel(displayTitle: model.displayTitle, isSelected: true))
        }
    }
    
    private func mapProgress(model: PlayingItem.Progress) -> ProgressViewModel {
        .init(
            currentTimeLabel: mapCurrentTimeLabel(model.currentTimeInSeconds),
            endTimeLabel: mapEndTimeLabel(model.totalTime),
            progressTimePercentage: model.progressTimePercentage.roundToDecimal(2)
        )
    }
    
    public func didReceivePlayerState(with playingItem: PlayingItem) {
        resourceView.display(viewModel: map(playingItem: playingItem))
    }
    
    public func didReceiveFutureProgressAfterSeek(with progress: PlayingItem.Progress) {
        resourceView.diplayFuturePrepareForSeekProgress(with: mapProgress(model: progress))
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
    
    public func onSelectSpeedPlayback() {
        resourceView.displaySpeedPlaybackSelection(with: playbackSpeedList)
    }
    
    public func map(playbackSpeed: PlaybackSpeed) -> SpeedPlaybackItemViewModel {
        SpeedPlaybackItemViewModel(
            displayTitle: playbackSpeed.displayTitle,
            isSelected: playbackSpeed == selectedSpeed
        )
    }
}

private extension Float {
    func roundToDecimal(_ fractionDigits: Int) -> Float {
        let multiplier = pow(10, Float(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

private extension PlaybackSpeed {
    
    var displayTitle: String {
        switch self {
        case .x0_75:
            return "0.75x"
        case .x1:
            return "1x"
        case .x1_25:
            return "1.25x"
        case .x1_5:
            return "1.5x"
        case .x2:
            return "2x"
        }
    }
}
