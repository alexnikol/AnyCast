// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class LocalPlaybackProgressLoader {
    public typealias SaveResult = Error?
    
    private let store: PlaybackProgressStore
    private let currentDate: () -> Date
    
    public init(store: PlaybackProgressStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ playingItem: AudioPlayerModule.PlayingItem, completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedPlayingItem(completion: { [weak self] deletion in
            guard let self = self else { return }
            
            if let deletion = deletion {
                completion(deletion)
            } else {
                self.cache(playingItem, completion: completion)
            }
        })
    }
    
    private func cache(_ playingItem: PlayingItem, completion: @escaping (SaveResult) -> Void) {
        self.store.insert(playingItem.toLocal(), timestamp: currentDate(), completion: { [weak self] insertionError in
            guard self != nil else { return }
            
            completion(insertionError)
        })
    }
}

private extension PlayingItem {
    func toLocal() -> LocalPlayingItem {
        LocalPlayingItem(
            episode: LocalPlayingEpisode(
                id: episode.id,
                title: episode.title,
                thumbnail: episode.thumbnail,
                audio: episode.audio,
                publishDateInMiliseconds: episode.publishDateInMiliseconds
            ),
            podcast: LocalPlayingPodcast(
                id: podcast.id,
                title: podcast.title,
                publisher: podcast.publisher),
            updates: updates.map( { $0.toLocal() })
        )
    }
}

private extension PlayingItem.State {
    func toLocal() -> LocalPlayingItem.State {
        switch self {
        case .playback(let playbackState):
            return .playback(playbackState.toLocal())
            
        case .volumeLevel(let float):
            return .volumeLevel(float)
            
        case .progress(let progress):
            return .progress(progress.toLocal())
            
        case .speed(let playbackSpeed):
            return .speed(playbackSpeed)
        }
    }
}

private extension PlayingItem.PlaybackState {
    func toLocal() -> LocalPlayingItem.PlaybackState {
        switch self {
        case .playing:
            return .playing
            
        case .pause:
            return .pause
            
        case .loading:
            return .loading
        }
    }
}

private extension PlayingItem.Progress {
    func toLocal() -> LocalPlayingItem.Progress {
        .init(
            currentTimeInSeconds: currentTimeInSeconds,
            totalTime: totalTime.toLocal(),
            progressTimePercentage: progressTimePercentage
        )
    }
}

private extension EpisodeDuration {
    func toLocal() -> LocalEpisodeDuration {
        switch self {
        case .notDefined:
            return .notDefined
            
        case .valueInSeconds(let value):
            return .valueInSeconds(value)
        }
    }
}
