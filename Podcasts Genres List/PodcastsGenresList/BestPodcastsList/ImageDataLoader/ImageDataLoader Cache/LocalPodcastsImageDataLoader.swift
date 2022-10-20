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
    
    private let store: PodcastsImageDataStore
    
    public init(store: PodcastsImageDataStore) {
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

extension LocalPodcastsImageDataLoader {
    public typealias SaveResult = Swift.Result<Void, Swift.Error>
    
    public enum SaveError: Swift.Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.save(data, for: url, completion: { [weak self] result in
            guard self != nil else { return }
            
            completion(result.mapError { _ in SaveError.failed })
        })
    }
}
