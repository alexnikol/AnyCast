// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import BestPodcastsList

class BestPodcastsLoaderSpy: BestPodcastsLoader {
    
    private var bestPodcastRequests: [(BestPodcastsLoader.Result) -> Void] = []
    
    var loadCallCount: Int {
        return bestPodcastRequests.count
    }
    
    func load(by genreID: Int, completion: @escaping (BestPodcastsLoader.Result) -> Void) {
        bestPodcastRequests.append(completion)
    }
    
    func completeBestPodcastsLoading(with bestPodcastsList: BestPodcastsList = .init(genreId: 1, genreName: "any genre name", podcasts: []), at index: Int) {
        bestPodcastRequests[index](.success(bestPodcastsList))
    }
    
    func completeBestPodcastsLoadingWithError(at index: Int) {
        let error = NSError(domain: "any error", code: 0)
        bestPodcastRequests[index](.failure(error))
    }
}
