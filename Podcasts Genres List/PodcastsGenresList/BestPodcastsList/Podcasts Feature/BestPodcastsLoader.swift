// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol BestPodcastsLoader {
    typealias Result = Swift.Result<BestPodcastsList, Error>
    
    func load(by genreID: Int, completion: @escaping (Result) -> Void)
}
