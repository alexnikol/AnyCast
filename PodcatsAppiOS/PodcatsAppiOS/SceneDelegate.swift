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
    
    private var appCoordinator: GenresCoordinator?
    
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
        let rootNavigation = UINavigationController()
        appCoordinator = GenresCoordinator(
            navigationController: rootNavigation,
            baseURL: baseURL,
            httpClient: httpClient,
            localGenresLoader: localGenresLoader
        )
        appCoordinator?.start()
        window?.rootViewController = rootNavigation
        window?.makeKeyAndVisible()
    }
}
