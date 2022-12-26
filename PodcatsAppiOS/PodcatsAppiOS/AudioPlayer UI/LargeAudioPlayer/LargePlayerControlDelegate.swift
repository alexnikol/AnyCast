// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsModule

protocol LargePlayerControlDelegate {
    func openPlayer()
    func startPlaybackAndOpenPlayer(episode: Episode, podcast: PodcastDetails)
}
