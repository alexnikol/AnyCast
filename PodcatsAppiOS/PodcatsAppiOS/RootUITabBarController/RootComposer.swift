// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import HTTPClient
import PodcastsGenresList
import AudioPlayerModule
import SearchContentModule

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
        let tabBarPresenter = RootTabBarPresenter()
        let tabBarPresentationAdapter = RootTabBarPresentationAdapter(statePublisher: audioPlayerStatePublisher)
        tabBarPresentationAdapter.presenter = tabBarPresenter
        
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
            title: tabBarPresenter.exploreTabBarItemTitle,
            image: UIImage(systemName: "rectangle.grid.2x2.fill")?.withTintColor(TabbarColors.defaultColor),
            selectedImage: UIImage(systemName: "rectangle.grid.2x2.fill")?.withTintColor(TabbarColors.selectedColor)
        )
        exploreCoordinator.start()
        
        let typeheadController = TypeheadSearchUIComposer
            .searchComposedWith(searchLoader: { term in
                Deferred {
                    Future { completion in
                        let aray = ["\(term) 1", "\(term) 2", "\(term) 2" ,"\(term) 2" ,"\(term) 2"]
                        let result = TypeheadSearchContentResult(
                            terms: aray + aray + aray + aray + aray,
                            genres: [],
                            podcasts: []
                        )
                        completion(.success(result))
                    }
                }
                .delay(for: 0.5, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
            })
        let searchController = UISearchController(searchResultsController: typeheadController)
        searchController.searchBar.delegate = typeheadController
        
        let (generalSearch, generalSourceDelegate) = GeneralSearchUIComposer.searchComposedWith(searchController: searchController)
        let searchNavigation = UINavigationController(rootViewController: generalSearch)
        searchNavigation.tabBarItem = UITabBarItem(
            title: tabBarPresenter.searchTabBarItemTitle,
            image: UIImage(systemName: "waveform.and.magnifyingglass")?.withTintColor(TabbarColors.defaultColor),
            selectedImage: UIImage(systemName: "waveform.and.magnifyingglass")?.withTintColor(TabbarColors.selectedColor)
        )
        
        let episodeThumbnailLoaderService = EpisodeThumbnailLoaderService(
            httpClient: httpClient,
            podcastsImageDataStore: PodcastsImageDataStoreContainer.shared.podcastsImageDataStore
        )
        let stickyPlayer = StickyAudioPlayerUIComposer.playerWith(
            thumbnailURL: URL(string: "https://123123123")!,
            statePublisher: audioPlayerStatePublisher,
            controlsDelegate: audioPlayer,
            imageLoader: episodeThumbnailLoaderService.makeRemotePodcastImageDataLoader(for:),
            onPlayerOpen: exploreCoordinator.openPlayer
        )
        
        let rootTabBarController = RootTabBarController(
            stickyAudioPlayerController: stickyPlayer,
            viewDelegate: tabBarPresentationAdapter
        )
        tabBarPresenter.view = rootTabBarController
        rootTabBarController.setViewControllers([exploreNavigation, searchNavigation], animated: false)
        return rootTabBarController
    }
}
