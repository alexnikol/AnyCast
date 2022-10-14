// Copyright © 2022 Almost Engineer. All rights reserved.

import Combine
import PodcastsGenresList

public extension GenresLoader {
    typealias Publisher = AnyPublisher<[Genre], Error>
    
    func loadPublisher() -> Publisher {
        Deferred {
            Future(load)
        }.eraseToAnyPublisher()
    }
}

extension Publisher {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}

extension Publisher where Output == [Genre] {
    func caching(to cache: GenresCache) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { genres in
            cache.save(genres, completion: { _ in })
        }).eraseToAnyPublisher()
    }
}
