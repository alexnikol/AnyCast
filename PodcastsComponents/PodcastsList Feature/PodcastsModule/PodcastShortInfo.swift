// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

protocol PodcastShortInfo {
    var id: String { get }
    var title: String { get }
    var publisher: String { get }
    var language: String { get }
    var type: PodcastType { get }
    var image: URL { get }
}
