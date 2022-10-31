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
    
    private let currentDate: () -> Date
    private let store: PodcastsImageDataStore
    
    public init(store: PodcastsImageDataStore, currentDate: @escaping () -> Date) {
        self.currentDate = currentDate
        self.store = store
    }
    
    public func loadImageData(from url: URL, completion: @escaping (PodcastImageDataLoader.Result) -> Void) -> PodcastImageDataLoaderTask {
        let task = Task(completion: completion)
        
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            var loaderRetrieveResult: LocalPodcastsImageDataLoader.Result
            
            switch result {
            case .empty:
                loaderRetrieveResult = .failure(Error.notFound)
                
            case let .found(cache, _):
                loaderRetrieveResult = .success(cache.data)
                
            case .failure:
                loaderRetrieveResult = .failure(Error.failed)
            }
            
            task.complete(with: loaderRetrieveResult)
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
        store.insert(data, for: url, with: currentDate(), completion: { [weak self] result in
            guard self != nil else { return }
            
            completion(result.mapError { _ in SaveError.failed })
        })
    }
}
