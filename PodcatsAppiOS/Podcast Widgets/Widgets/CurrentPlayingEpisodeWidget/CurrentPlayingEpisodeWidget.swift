// Copyright © 2023 Almost Engineer. All rights reserved.

import WidgetKit
import CoreData
import SwiftUI
import PodcastsModule
import AudioPlayerModule
import HTTPClient
import URLSessionHTTPClient

struct CurrentPlayingEpisodeWidget: Widget {
    private let playbackProgressProvider: PlaybackProgressProvider
    let kind: String = "Podcast_CurrentPlayingEpisodeWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: CurrentPlayingEpisodeWidgetProvider(playbackProgressProvider: playbackProgressProvider)
        ) { entry in
            CurrentPlayingEpisodeView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
    
    init() {
        let playbackProgressStore = try! CoreDataPlaybackProgressStore(
            storeURL: FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.com.podcats")!
                .appendingPathComponent("playback-progress-store.sqlite")
        )
        let podcastsImageDataStore = try! CoreDataPodcastsImageDataStore(
            storeURL: FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.com.podcats")!
                .appendingPathComponent("best-podcasts-image-data-store.sqlite")
        )
        
        let httpClient: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        playbackProgressProvider = PlaybackProgressProvider(
            localPlaybackProgressLoader: LocalPlaybackProgressLoader(
                store: playbackProgressStore,
                currentDate: Date.init
            ),
            episodeThumbnailLoaderService: EpisodeThumbnailLoaderService(
                httpClient: httpClient,
                podcastsImageDataStore: podcastsImageDataStore
            )
        )
    }
}
