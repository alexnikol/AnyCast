// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import HTTPClient
import PodcastsGenresList
import AudioPlayerModule

final class RootComposer {
    
    private init() {}
    
    static func compose(
        baseURL: URL,
        httpClient: HTTPClient,
        localGenresLoader: LocalGenresLoader,
        audioPlayer: AudioPlayer,
        audioPlayerStatePublisher: AudioPlayerStatePublisher
    ) -> UIViewController {
        let exploreNavigation = UINavigationController()
        let exploreCoordinator = ExploreCoordinator(
            navigationController: exploreNavigation,
            baseURL: baseURL,
            httpClient: httpClient,
            localGenresLoader: localGenresLoader,
            audioPlayer: audioPlayer,
            audioPlayerStatePublisher: audioPlayerStatePublisher
        )
        exploreCoordinator.start()
        
        let rootTabBarController = UITabBarController()
        rootTabBarController.setViewControllers([
            exploreNavigation
        ], animated: false)
        return rootTabBarController
    }
}
