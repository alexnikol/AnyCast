// Copyright © 2023 Almost Engineer. All rights reserved.

import Foundation
import Combine
import AudioPlayerModule

final class PlaybackProgressProvider {
    private let localPlaybackProgressLoader: LocalPlaybackProgressLoader
    private let episodeThumbnailLoaderService: EpisodeThumbnailLoaderService
    private var store = Set<AnyCancellable>()
    
    init(localPlaybackProgressLoader: LocalPlaybackProgressLoader, episodeThumbnailLoaderService: EpisodeThumbnailLoaderService) {
        self.localPlaybackProgressLoader = localPlaybackProgressLoader
        self.episodeThumbnailLoaderService = episodeThumbnailLoaderService
    }
    
    typealias LoadResult = CurrentEpisodeState
    
    func load(completion: @escaping (CurrentEpisodeState) -> Void) {
        var currentPlayingItem: PlayingItem?
        var thumbnailData: Data?
        localPlaybackProgressLoader.loadPublisher()
            .flatMap { playingItem in
                currentPlayingItem = playingItem
                return self.episodeThumbnailLoaderService.makeRemotePodcastImageDataLoader(for: playingItem.episode.thumbnail)
            }
            .sink { completionResult in
                switch completionResult {
                case .failure:
                    completion(CurrentEpisodeState.noPlayingItem)
                    
                case .finished:
                    guard let currentPlayingItem = currentPlayingItem, let thumbnailData = thumbnailData else {
                        completion(CurrentEpisodeState.noPlayingItem)
                        return
                    }
                    let state = PlaybackProgressPresenter.map(currentPlayingItem, thumbnailData: thumbnailData)
                    completion(state)
                }
            } receiveValue: { imageData in
                thumbnailData = imageData
            }.store(in: &store)
    }
}
