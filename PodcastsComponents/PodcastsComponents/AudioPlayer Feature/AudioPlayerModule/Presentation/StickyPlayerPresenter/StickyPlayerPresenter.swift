// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol StickyAudioPlayerView {
    func display(viewModel: StickyAudioPlayerViewModel)
}

public class StickyAudioPlayerPresenter {
    private let resourceView: StickyAudioPlayerView
    private let calendar: Calendar
    private let locale: Locale
    
    public init(resourceView: StickyAudioPlayerView, calendar: Calendar = .current, locale: Locale = .current) {
        self.resourceView = resourceView
        self.calendar = calendar
        self.locale = locale
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = locale
        var newCalendar = calendar
        newCalendar.locale = locale
        formatter.calendar = calendar
        return formatter
    }()
    
    public func map(playingItem: PlayingItem) -> StickyAudioPlayerViewModel {
        let publishDate = Date(timeIntervalSince1970: TimeInterval(playingItem.episode.publishDateInMiliseconds / 1000))
        let displayPublishDate = dateFormatter.string(from: publishDate)
        
        var playBackStateViewModel: PlaybackStateViewModel = .init(playbackState: .pause)
        
        for update in playingItem.updates {
            switch update {
            case .playback(let playbackState):
                playBackStateViewModel = PlaybackStateViewModel(playbackState: playbackState)
                
            default: ()
            }
        }
        
        return StickyAudioPlayerViewModel(
            titleLabel: playingItem.episode.title,
            descriptionLabel: displayPublishDate,
            thumbnailURL: playingItem.episode.thumbnail,
            playbackViewModel: playBackStateViewModel
        )
    }
    
    public func didReceivePlayerState(with playingItem: PlayingItem) {
        resourceView.display(viewModel: map(playingItem: playingItem))
    }
}
