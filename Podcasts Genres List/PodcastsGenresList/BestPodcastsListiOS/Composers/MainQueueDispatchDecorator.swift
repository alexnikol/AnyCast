// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import BestPodcastsList

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: BestPodcastsLoader where T == BestPodcastsLoader {
    func load(by genreID: Int, completion: @escaping (BestPodcastsLoader.Result) -> Void) {
        decoratee.load(by: genreID, completion: { [weak self] result in
            self?.dispatch { completion(result) }
        })
    }
}
