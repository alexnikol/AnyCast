// Copyright © 2023 Almost Engineer. All rights reserved.

import Foundation
import Intents
import WidgetKit

struct CurrentEpisodeEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let state: CurrentEpisodeState
    
    static func placeholder() -> CurrentEpisodeEntry {
        CurrentEpisodeEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            state: .noPlayingItem
        )
    }
}
