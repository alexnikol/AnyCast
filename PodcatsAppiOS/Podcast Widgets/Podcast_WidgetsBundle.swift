// Copyright © 2023 Almost Engineer. All rights reserved.

import WidgetKit
import SwiftUI
import CoreData
import AudioPlayerModule

@main
struct Podcast_WidgetsBundle: WidgetBundle {
        
    var body: some Widget {
        CurrentPlayingEpisodeWidget()
    }
}
