// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class LocalPodcastsImageDataLoader: PodcastImageDataLoader {
    private class Task: PodcastImageDataLoaderTask {
        private var completion: ((PodcastImageDataLoader.Result) -> Void)?
        
        init(completion: @escaping (PodcastImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
        
        func complete(with result: PodcastImageDataLoader.Result) {
            completion?(result)
        }
    }
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    private let store: BestPodcastsStore
    
    public init(store: BestPodcastsStore) {
        self.store = store
    }
    
    public func loadImageData(from url: URL, completion: @escaping (PodcastImageDataLoader.Result) -> Void) -> PodcastImageDataLoaderTask {
        let task = Task(completion: completion)
        
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError { _ in Error.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(Error.notFound)
                }
            )
        }
        return task
    }
}
