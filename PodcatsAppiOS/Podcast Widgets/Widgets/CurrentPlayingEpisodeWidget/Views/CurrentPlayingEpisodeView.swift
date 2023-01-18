// Copyright © 2023 Almost Engineer. All rights reserved.

import WidgetKit
import SwiftUI
import Combine
import Intents
import AudioPlayerModule
import CoreData

struct CurrentPlayingEpisodeView: View {
    var entry: CurrentEpisodeEntry
    
    var body: some View {
        switch entry.state {
        case .playingItem(let model):
            PlayingEpisodeView(model: model)
            
        case .noPlayingItem:
            NoPlayingEpisodeView()
        }
    }
}

struct CurrentPlayingEpisodeView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CurrentPlayingEpisodeView(
                entry: CurrentEpisodeEntry(
                    date: Date(),
                    configuration: ConfigurationIntent(),
                    state: CurrentEpisodeState.noPlayingItem
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("No playing episode state")
            
            
            let playingItem = CurrentEpisodeWidgetViewModel(
                episodeTitle: "Episode title",
                podcastTitle: "Podcast title",
                timeLabel: "About 32 min remaining"
            )
            CurrentPlayingEpisodeView(
                entry: CurrentEpisodeEntry(
                    date: Date(),
                    configuration: ConfigurationIntent(),
                    state: CurrentEpisodeState.playingItem(playingItem)
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("No playing episode state")
        }
    }
}
