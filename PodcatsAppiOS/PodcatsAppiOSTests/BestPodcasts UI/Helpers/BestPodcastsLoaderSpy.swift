// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import BestPodcastsList

class BestPodcastsLoaderSpy: BestPodcastsLoader, PodcastImageDataLoader {

    private var bestPodcastRequests: [(BestPodcastsLoader.Result) -> Void] = []
    private(set) var cancelledImageURLs: [URL] = []
        
    // MARK: - BestPodcastsLoader
    
    func load(by genreID: Int, completion: @escaping (BestPodcastsLoader.Result) -> Void) {
        bestPodcastRequests.append(completion)
    }
    
    func podcastsPublisher(by genreID: Int) -> AnyPublisher<BestPodcastsList, Error> {
        return Deferred {
            Future { completion in
                self.load(by: genreID, completion: completion)
            }
        }.eraseToAnyPublisher()
    }
    
    func completeBestPodcastsLoading(with bestPodcastsList: BestPodcastsList = .init(genreId: 1, genreName: "any genre name", podcasts: []), at index: Int) {
        bestPodcastRequests[index](.success(bestPodcastsList))
    }
    
    func completeBestPodcastsLoadingWithError(at index: Int) {
        let error = NSError(domain: "any error", code: 0)
        bestPodcastRequests[index](.failure(error))
    }
    
    // MARK: - PodcastImageDataLoader
    
    private var imageRequests: [(url: URL, completion: (PodcastImageDataLoader.Result) -> Void)] = []
    
    var loadCallCount: Int {
        return bestPodcastRequests.count
    }
    
    var loadedImageURLs: [URL] {
        return imageRequests.map { $0.url }
    }
    
    func loadImageData(from url: URL, completion: @escaping (PodcastImageDataLoader.Result) -> Void) -> PodcastImageDataLoaderTask {
        imageRequests.append((url, completion))
        return Task { [weak self] in
            self?.cancelledImageURLs.append(url)
        }
    }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }
    
    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "any error", code: 0)
        imageRequests[index].completion(.failure(error))
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
