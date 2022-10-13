// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import CoreData
import PodcastsGenresList
import PodcastsGenresListiOS

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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    convenience init(httpClient: HTTPClient, genresStore: GenresStore) {
        self.init()
        self.httpClient = httpClient
        self.genresStore = genresStore
    }
    
    func configureWindow() {
        let genresController = GenresUIComposer.genresComposedWith(loader: makeLocalGenresLoaderWithRemoteFallback)
        let nav = UINavigationController(rootViewController: genresController)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    private func makeLocalGenresLoaderWithRemoteFallback() -> GenresLoader.Publisher {
        struct EmptyCache: Error {}
        
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let genresRequestPath = baseURL.appendingPathComponent("api/v2/genres")
        let remoteGenresLoader = RemoteGenresLoader(url: genresRequestPath, client: httpClient)
        let localGenresLoader = LocalGenresLoader(store: genresStore, currentDate: Date.init)
        return localGenresLoader
            .loadPublisher()
            .tryMap { genres in
                guard !genres.isEmpty else {
                    throw EmptyCache()
                }
                return genres
            }
            .fallback(to: {
                remoteGenresLoader
                    .loadPublisher()
                    .caching(to: localGenresLoader)
            })
    }
}
