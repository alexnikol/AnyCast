// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

final class MainQueueDisaptchDecorator<T> {
    private let decoratee: T
    
    init(_ decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension MainQueueDisaptchDecorator: GenresLoader where T == GenresLoader {
    func load(completion: @escaping (LoadGenresResult) -> Void) {
        self.decoratee.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
