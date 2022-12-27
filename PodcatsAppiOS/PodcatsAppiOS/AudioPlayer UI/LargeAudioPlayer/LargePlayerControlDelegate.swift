// Copyright © 2022 Almost Engineer. All rights reserved.

import AudioPlayerModule

protocol LargePlayerControlDelegate {
    func openPlayer()
    func startPlaybackAndOpenPlayer(episode: any PlayingEpisode, podcast: any PlayingPodcast)
}
