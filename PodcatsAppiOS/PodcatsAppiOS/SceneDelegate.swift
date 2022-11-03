// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import HTTPClient
import URLSessionHTTPClient
import Combine
import CoreData
import PodcastsGenresList
import PodcastsGenresListiOS
import BestPodcastsList
import BestPodcastsListiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var genresStore: GenresStore = {
        try! CoreDataGenresStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("genres-store.sqlite"),
            bundle: Bundle(for: CoreDataGenresStore.self))
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
        
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let genresRequestPath = baseURL.appendingPathComponent("api/v2/genres")
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
                    .loadPublisher(from: genresRequestPath)
                    .tryMap(GenresItemsMapper.map)
                    .caching(to: localGenresLoader)
            })
    }
    
    func showBestPodcasts(byGenre genre: Genre) {
        let podcasts = BestPodcastsUIComposer.bestPodcastComposed(
            genreID: genre.id,
            podcastsLoader: makeBestPodcastsRemoteLoader,
            imageLoader: RemoteImageDataLoader(client: httpClient)
        )
        (window?.rootViewController as? UINavigationController)?.pushViewController(podcasts, animated: true)
    }
    
    private func makeBestPodcastsRemoteLoader(byGenreID genreID: Int) -> AnyPublisher<BestPodcastsList, Swift.Error> {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = "listen-api-test.listennotes.com"
        urlBuilder.path = "/api/v2/best_podcasts"
        urlBuilder.queryItems = [URLQueryItem(name: "genre_id", value: String(genreID))]
        return httpClient
            .loadPublisher(from: urlBuilder.url!)
            .tryMap(BestPodastsItemsMapper.map)
            .eraseToAnyPublisher()
    }
}
