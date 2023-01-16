// Copyright © 2023 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule

final class PlaybackProgressPresenter {
    
    private init() {}
    
    static func map(_ playingItem: PlayingItem, thumbnailData: Data) -> CurrentEpisodeState {
        var timeLabel = ""
       
        for update in playingItem.updates {
            switch update {
            case let .progress(progress):
                timeLabel = String(progress.progressTimePercentage)
                
            default:
                continue
            }
        }
        
        let model = PlayingEpisodeModel(
            episodeTitle: playingItem.episode.title,
            podcastTitle: playingItem.podcast.title,
            timeLabel: timeLabel,
            thumbnailData: thumbnailData
        )
        return .playingItem(model)
    }
}
