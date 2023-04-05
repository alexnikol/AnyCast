// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule

extension XCTestCase {
    
    func makePlayingItemModels() -> (model: PlayingItem, localModel: LocalPlayingItem) {
        let episode = makeUniqueEpisode()
        let podcast = makePodcast()
        let model = PlayingItem(
            episode: episode,
            podcast: podcast,
            updates: [
                .playback(.playing),
                .progress(
                    .init(
                        currentTimeInSeconds: 10,
                        totalTime: .notDefined,
                        progressTimePercentage: 0.1
                    )
                ),
                .volumeLevel(0.5)
            ]
        )
        
        let localEpisode = LocalPlayingEpisode(
            id: episode.id,
            title: episode.title,
            thumbnail: episode.thumbnail,
            audio: episode.audio,
            publishDateInMiliseconds: episode.publishDateInMiliseconds
        )
        
        let localPodcast = LocalPlayingPodcast(id: podcast.id, title: podcast.title, publisher: podcast.publisher)
        
        let localModel = LocalPlayingItem(
            episode: localEpisode,
            podcast: localPodcast,
            updates: [
                .playback(.playing),
                .progress(
                    .init(
                        currentTimeInSeconds: 10,
                        totalTime: .notDefined,
                        progressTimePercentage: 0.1
                    )
                ),
                .volumeLevel(0.5)
            ]
        )
        
        return (model, localModel)
    }
}
