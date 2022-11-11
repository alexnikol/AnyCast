// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import PodcastsModule

class PodcastDetailsLoaderSpy: PodcastImageDataLoader {
    
    typealias Result = Swift.Result<PodcastDetails, Error>
    
    private var podcastDetailsRequests: [(Result) -> Void] = []
    private(set) var cancelledImageURLs: [URL] = []
    
    // MARK: - PodcastDetails Loader
    
    func load(by podcastID: String, completion: @escaping (Result) -> Void) {
        podcastDetailsRequests.append(completion)
    }
    
    func podcastDetailsPublisher(by podcastID: String) -> AnyPublisher<PodcastDetails, Error> {
        return Deferred {
            Future { completion in
                self.load(by: podcastID, completion: completion)
            }
        }.eraseToAnyPublisher()
    }
    
    func completePodcastDetailsLoading(with podcastDetails: PodcastDetails = PodcastDetails.default, at index: Int) {
        podcastDetailsRequests[index](.success(podcastDetails))
    }
    
    func completePodcastDetailsLoadingWithError(at index: Int) {
        let error = NSError(domain: "any error", code: 0)
        podcastDetailsRequests[index](.failure(error))
    }
    
    // MARK: - PodcastImageDataLoader
    
    private var imageRequests: [(url: URL, completion: (PodcastImageDataLoader.Result) -> Void)] = []
    
    var loadCallCount: Int {
        return podcastDetailsRequests.count
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
    
    func imageDataPublisher(from url: URL) -> AnyPublisher<Data, Error> {
        var task: PodcastImageDataLoaderTask?
        return Deferred {
            Future { completion in
                task = self.loadImageData(from: url, completion: completion)
            }
            .handleEvents(receiveCancel: {
                task?.cancel()
            })
        }.eraseToAnyPublisher()
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

private extension PodcastDetails {
    static var `default`: PodcastDetails {
        PodcastDetails(
            id: UUID().uuidString,
            title: "Any Title",
            publisher: "Any Publisher",
            language: "Any Language",
            type: .serial,
            image: anyURL(),
            episodes: [Episode.default, Episode.default],
            description: "Any Description",
            totalEpisodes: 100
        )
    }
}

private extension Episode {
    static var `default`: Episode {
        .init(
            id: UUID().uuidString,
            title: "Any Episode title",
            description: "Any Episode description",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: 200,
            containsExplicitContent: false,
            publishDateInMiliseconds: 1478937602017
        )
    }
}
