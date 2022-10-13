// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList
import PodcastsGenresListiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    convenience init(httpClient: HTTPClient) {
        self.init()
        self.httpClient = httpClient
    }
    
    func configureWindow() {
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let genresRequestPath = baseURL.appendingPathComponent("api/v2/genres")
        let genresLoader = RemoteGenresLoader(url: genresRequestPath, client: httpClient)
        let genresController = GenresUIComposer.genresComposedWith(loader: genresLoader)
        let nav = UINavigationController(rootViewController: genresController)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
