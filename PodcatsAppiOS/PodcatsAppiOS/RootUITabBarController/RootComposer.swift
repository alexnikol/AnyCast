// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import HTTPClient
import PodcastsGenresList
import AudioPlayerModule

final class RootComposer {
    
    enum TabbarColors {
        static let selectedColor = UIColor.accentColor
        static let defaultColor = UIColor.label
    }
    
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
        exploreNavigation.tabBarItem = UITabBarItem(
            title: RootTabBarControllerPresenter.exploreTabBarItemTitle,
            image: UIImage(systemName: "waveform.and.magnifyingglass")?.withTintColor(TabbarColors.defaultColor),
            selectedImage: UIImage(systemName: "waveform.and.magnifyingglass")?.withTintColor(TabbarColors.selectedColor)
        )
        
        exploreCoordinator.start()
        let rootTabBarController = RootTabBarController()
        rootTabBarController.setViewControllers([exploreNavigation], animated: false)
        return rootTabBarController
    }
}
