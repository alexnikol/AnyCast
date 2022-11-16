// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData
import Combine
import HTTPClient
import PodcastsModule

class PodcastDetailsService {
    private let baseURL: URL
    private let httpClient: HTTPClient
        
    private let podcastsImageDataStore: PodcastsImageDataStore
    
    private lazy var remoteLoader: RemoteImageDataLoader = {
        RemoteImageDataLoader(client: httpClient)
    }()
    
    init(baseURL: URL, httpClient: HTTPClient, podcastsImageDataStore: PodcastsImageDataStore) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.podcastsImageDataStore = podcastsImageDataStore
    }
    
    func makeRemotePodcastDetailsLoader(byPodcastID podcastID: String) -> AnyPublisher<PodcastDetails, Swift.Error> {
        let requestURL = PodcastsEndpoint.getPodcastDetails(podcastID: podcastID).url(baseURL: baseURL)
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(PodcastDetailsMapper.map)
            .eraseToAnyPublisher()
    }
        
    func makeRemotePodcastImageDataLoader(for url: URL) -> AnyPublisher<Data, Error> {
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
