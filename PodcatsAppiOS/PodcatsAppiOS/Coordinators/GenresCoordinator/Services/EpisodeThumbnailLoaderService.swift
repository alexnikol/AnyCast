// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData
import Combine
import HTTPClient
import PodcastsModule

final class EpisodeThumbnailLoaderService {
    private let httpClient: HTTPClient
    private let podcastsImageDataStore: PodcastsImageDataStore
    
    private lazy var remoteLoader: RemoteImageDataLoader = {
        RemoteImageDataLoader(client: httpClient)
    }()
    
    init(httpClient: HTTPClient, podcastsImageDataStore: PodcastsImageDataStore) {
        self.httpClient = httpClient
        self.podcastsImageDataStore = podcastsImageDataStore
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
