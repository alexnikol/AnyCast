// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData
import Combine
import HTTPClient
import PodcastsModule

final class BestPodcastsService {
    private let baseURL: URL
    private let httpClient: HTTPClient
    
    private lazy var podcastsImageDataStore: PodcastsImageDataStore = {
        try! CoreDataPodcastsImageDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("best-podcasts-image-data-store.sqlite")
        )
    }()
    
    init(baseURL: URL, httpClient: HTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
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
        let remoteLoader = RemoteImageDataLoader(client: httpClient)
        
        return localLoader
            .loadPublisher(from: url)
            .fallback(to: {
                remoteLoader
                    .loadPublisher(from: url)
                    .caching(to: localLoader, for: url)
            })
            .eraseToAnyPublisher()
    }
}
