// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList
import PodcastsGenresListiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    private func configureWindow() {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let genresRequestPath = baseURL.appendingPathComponent("api/v2/genres")
        let genresLoader = RemoteGenresLoader(url: genresRequestPath, client: httpClient)
        let genresController = GenresUIComposer.genresComposedWith(loader: genresLoader)
        let nav = UINavigationController(rootViewController: genresController)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
