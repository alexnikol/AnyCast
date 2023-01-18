// Copyright © 2023 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule

enum CurrentEpisodeState {
    case playingItem(CurrentEpisodeWidgetViewModel)
    case noPlayingItem
}
