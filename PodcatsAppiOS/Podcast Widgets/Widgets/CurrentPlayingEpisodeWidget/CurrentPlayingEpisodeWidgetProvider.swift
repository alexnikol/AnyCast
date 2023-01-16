// Copyright © 2023 Almost Engineer. All rights reserved.

import Intents
import WidgetKit

struct CurrentPlayingEpisodeWidgetProvider: IntentTimelineProvider {
    private let playbackProgressProvider: PlaybackProgressProvider
    
    func placeholder(in context: Context) -> CurrentEpisodeEntry {
        return CurrentEpisodeEntry.placeholder()
    }
    
    func getSnapshot(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (CurrentEpisodeEntry) -> ()
    ) {
        playbackProgressProvider.load { state in
            let entry = CurrentEpisodeEntry(date: Date(), configuration: ConfigurationIntent(), state: state)
            completion(entry)
        }
    }
    
    func getTimeline(
        for configuration: ConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<CurrentEpisodeEntry>) -> ()
    ) {
        playbackProgressProvider.load { state in
            var entries: [CurrentEpisodeEntry] = []
            let entry = CurrentEpisodeEntry(date: Date(), configuration: ConfigurationIntent(), state: state)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    init(playbackProgressProvider: PlaybackProgressProvider) {
        self.playbackProgressProvider = playbackProgressProvider
    }
}
