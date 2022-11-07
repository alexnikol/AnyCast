// Copyright © 2022 Almost Engineer. All rights reserved.

import Combine
import HTTPClient
import PodcastsGenresList
import Foundation

extension LocalGenresLoader {
    typealias Publisher = AnyPublisher<[Genre], Error>
    
    func loadPublisher() -> Publisher {
        Deferred {
            Future(self.load)
        }.eraseToAnyPublisher()
    }
}

extension Publisher where Output == [Genre] {
    func caching(to cache: GenresCache) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { genres in
            cache.save(genres, completion: { _ in })
        }).eraseToAnyPublisher()
    }
}
