// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class LocalPodcastsImageDataLoader: ImageDataLoader {
    private class Task: ImageDataLoaderTask {
        private var completion: ((ImageDataLoader.Result) -> Void)?
        
        init(completion: @escaping (ImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
        
        func complete(with result: ImageDataLoader.Result) {
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
    
    public func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
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
