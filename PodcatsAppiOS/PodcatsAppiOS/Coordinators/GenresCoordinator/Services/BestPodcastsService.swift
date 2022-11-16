// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData
import Combine
import HTTPClient
import PodcastsModule

final class BestPodcastsService {
    private let baseURL: URL
    private let httpClient: HTTPClient
        
    private lazy var remoteLoader: RemoteImageDataLoader = {
        RemoteImageDataLoader(client: httpClient)
    }()
    
    private let podcastsImageDataStore: PodcastsImageDataStore
    
    init(baseURL: URL, httpClient: HTTPClient, podcastsImageDataStore: PodcastsImageDataStore) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.podcastsImageDataStore = podcastsImageDataStore
    }
    
    func makeBestPodcastsRemoteLoader(byGenreID genreID: Int) -> AnyPublisher<BestPodcastsList, Swift.Error> {
        let requestURL = PodcastsEndpoint.getBestPodcasts(genreID: genreID).url(baseURL: baseURL)
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(BestPodastsItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    func makeLocalPodcastImageDataLoaderWithRemoteFallback(for url: URL) -> AnyPublisher<Data, Error> {
        let localLoader = LocalPodcastsImageDataLoader(store: podcastsImageDataStore, currentDate: Date.init)
        return localLoader
            .loadPublisher(from: url)
            .fallback(to: { [weak remoteLoader] in
                remoteLoader?
                    .loadPublisher(from: url)
                    .caching(to: localLoader, for: url) ?? Empty().eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
}
