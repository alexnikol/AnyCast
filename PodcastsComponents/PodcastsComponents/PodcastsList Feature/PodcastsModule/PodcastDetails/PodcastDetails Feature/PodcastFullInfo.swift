// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

protocol PodcastFullInfo: PodcastShortInfo {
    var episodes: [Episode] { get }
    var description: String { get }
    var totalEpisodes: Int { get }
}
