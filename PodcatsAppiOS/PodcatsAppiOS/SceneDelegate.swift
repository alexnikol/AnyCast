// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import HTTPClient
import URLSessionHTTPClient
import Combine
import CoreData
import PodcastsGenresList
import PodcastsGenresListiOS
import PodcastsModule
import PodcastsModuleiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var baseURL: URL = {
        URL(string: "https://listen-api-test.listennotes.com")!
    }()
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var genresStore: GenresStore = {
        try! CoreDataGenresStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("genres-store.sqlite")
        )
    }()
    
    private lazy var podcastsImageDataStore: PodcastsImageDataStore = {
        try! CoreDataPodcastsImageDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("best-podcasts-image-data-store.sqlite")
        )
    }()
    
    private lazy var localGenresLoader: LocalGenresLoader = {
        LocalGenresLoader(store: genresStore, currentDate: Date.init)
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localGenresLoader.validateCache()
    }
    
    convenience init(httpClient: HTTPClient, genresStore: GenresStore) {
        self.init()
        self.httpClient = httpClient
        self.genresStore = genresStore
    }
    
    func configureWindow() {
        let rootController = configureGenresUI()
        let nav = UINavigationController(rootViewController: rootController)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func configureGenresUI() -> UIViewController {
        return GenresUIComposer.genresComposedWith(
            loader: makeLocalGenresLoaderWithRemoteFallback,
            selection: showBestPodcasts
        )
    }
    
    private func makeLocalGenresLoaderWithRemoteFallback() -> AnyPublisher<[Genre], Error> {
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
    
    func showBestPodcasts(byGenre genre: Genre) {
        let podcasts = BestPodcastsUIComposer.bestPodcastComposed(
            genreID: genre.id,
            podcastsLoader: makeBestPodcastsRemoteLoader,
            imageLoader: makeLocalPodcastImageDataLoaderWithRemoteFallback(for:),
            selection: showPodcastDetails
        )
        (window?.rootViewController as? UINavigationController)?.pushViewController(podcasts, animated: true)
    }
    
    func showPodcastDetails(byPodcast podcast: Podcast) {
        let podcasts = PodcastDetailsUIComposer.podcastDetailsComposedWith(
            podcastID: podcast.id,
            podcastsLoader: makeRemotePodcastDetailsLoader,
            imageLoader: makeLocalPodcastImageDataLoaderWithRemoteFallback(for:)
        )
        (window?.rootViewController as? UINavigationController)?.pushViewController(podcasts, animated: true)
    }
    
    private func makeBestPodcastsRemoteLoader(byGenreID genreID: Int) -> AnyPublisher<BestPodcastsList, Swift.Error> {
        let requestURL = PodcastsEndpoint.getBestPodcasts(genreID: genreID).url(baseURL: baseURL)
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(BestPodastsItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeLocalPodcastImageDataLoaderWithRemoteFallback(for url: URL) -> AnyPublisher<Data, Error> {
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
        
    private func makeRemotePodcastDetailsLoader(byPodcastID podcastID: String) -> AnyPublisher<PodcastDetails, Swift.Error> {
        let requestURL = PodcastsEndpoint.getPodcastDetails(podcastID: podcastID).url(baseURL: baseURL)
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(PodcastDetailsMapper.map)
            .eraseToAnyPublisher()
    }
}
