// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol PlayingEpisode: Equatable {
    var id: String { get }
    var title: String { get }
    var thumbnail: URL { get }
    var publishDateInMiliseconds: Int { get }
}
