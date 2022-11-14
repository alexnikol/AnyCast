// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData
import Combine
import PodcastsGenresList
import HTTPClient

final class GenresLoaderService {
    private let baseURL: URL
    private let httpClient: HTTPClient
        
    private let localGenresLoader: LocalGenresLoader
    
    init(baseURL: URL, httpClient: HTTPClient, localGenresLoader: LocalGenresLoader) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localGenresLoader = localGenresLoader
    }
    
    func makeLocalGenresLoaderWithRemoteFallback() -> AnyPublisher<[Genre], Error> {
        struct EmptyCache: Error {}
        let requestURL = GenresEndpoint.getGenres.url(baseURL: baseURL)
        let localGenresLoader = localGenresLoader
        return localGenresLoader
            .loadPublisher()
            .tryMap { genres in
                guard !genres.isEmpty else {
                    throw EmptyCache()
                }
                return genres
            }
            .fallback(to: { [weak self] in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.httpClient
                    .loadPublisher(from: requestURL)
                    .tryMap(GenresItemsMapper.map)
                    .caching(to: localGenresLoader)
            })
    }
}
