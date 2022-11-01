// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import BestPodcastsList

class BestPodcastsLoaderSpy: BestPodcastsLoader, PodcastImageDataLoader {

    private var bestPodcastRequests: [(BestPodcastsLoader.Result) -> Void] = []
    private(set) var loadedImageURLs: [URL] = []
    private(set) var cancelledImageURLs: [URL] = []
    
    var loadCallCount: Int {
        return bestPodcastRequests.count
    }
    
    // MARK: - BestPodcastsLoader
    
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
    
    // MARK: - PodcastImageDataLoader
    
    func loadImageData(from url: URL, completion: @escaping (PodcastImageDataLoader.Result) -> Void) -> PodcastImageDataLoaderTask {
        loadedImageURLs.append(url)
        return Task { [weak self] in
            self?.cancelledImageURLs.append(url)
        }
    }
    
    private struct Task: PodcastImageDataLoaderTask {
        private let callback: () -> Void
        
        init(callback: @escaping () -> Void) {
            self.callback = callback
        }
        
        func cancel() {
            callback()
        }
    }
}
