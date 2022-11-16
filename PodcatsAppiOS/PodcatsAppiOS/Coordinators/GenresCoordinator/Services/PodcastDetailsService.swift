// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData
import Combine
import HTTPClient
import PodcastsModule

class PodcastDetailsService {
    private let baseURL: URL
    private let httpClient: HTTPClient
    
    private lazy var podcastsImageDataStore: PodcastsImageDataStore = {
        try! CoreDataPodcastsImageDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("best-podcasts-image-data-store.sqlite")
        )
    }()
    
    private lazy var remoteLoader: RemoteImageDataLoader = {
        RemoteImageDataLoader(client: httpClient)
    }()
    
    init(baseURL: URL, httpClient: HTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
    }
    
    func makeRemotePodcastDetailsLoader(byPodcastID podcastID: String) -> AnyPublisher<PodcastDetails, Swift.Error> {
        let requestURL = PodcastsEndpoint.getPodcastDetails(podcastID: podcastID).url(baseURL: baseURL)
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(PodcastDetailsMapper.map)
            .eraseToAnyPublisher()
    }
        
    func makeRemotePodcastImageDataLoader(for url: URL) -> AnyPublisher<Data, Error> {
        return remoteLoader
            .loadPublisher(from: url)
            .eraseToAnyPublisher()
    }
}
