//
//  AppDelegate.swift
//  PodcatsAppiOS
//
//  Created by Alexander Nikolaychuk on 16.09.2022.
//

import UIKit
import PodcastsGenresList
import PodcastsGenresListiOS

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let genresRequestPath = baseURL.appendingPathComponent("api/v2/genres")
        let genresLoader = RemoteGenresLoader(url: genresRequestPath, client: httpClient)
        let genresController = GenresUIComposer.genresComposedWith(loader: genresLoader)
        let nav = UINavigationController(rootViewController: genresController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}
