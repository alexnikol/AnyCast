// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import HTTPClient
import SearchContentModule
import SearchContentModuleiOS
import AudioPlayerModule
import AudioPlayerModuleiOS
import PodcastsModule
import PodcastsModuleiOS

final class SearchCoordinator {
    private let navigationController: UINavigationController
    private let baseURL: URL
    private let httpClient: HTTPClient
    private let audioPlayer: AudioPlayer
    private let audioPlayerStatePublisher: AudioPlayerStatePublisher
    private var largePlayerController: LargeAudioPlayerViewController?
    
    init(navigationController: UINavigationController,
         baseURL: URL,
         httpClient: HTTPClient,
         audioPlayer: AudioPlayer,
         audioPlayerStatePublisher: AudioPlayerStatePublisher) {
        self.navigationController = navigationController
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.audioPlayer = audioPlayer
        self.audioPlayerStatePublisher = audioPlayerStatePublisher
    }
    
    func start() {
        navigationController.setViewControllers([createSearchScreen()], animated: false)
    }
    
    func openPlayer() {
        guard let largePlayerController = largePlayerController else {
            largePlayerController = createPlayer()
            openPlayer()
            
            return
        }
        present(screen: largePlayerController)
    }
    
    private func show(screen: UIViewController) {
        self.navigationController.pushViewController(screen, animated: true)
    }
    
    private func present(screen: UIViewController) {
        self.navigationController.showDetailViewController(screen, sender: self)
    }
    
    private func createSearchScreen() -> UIViewController {
        var searchSourceDelegate: GeneralSearchSourceDelegate?
        let typeaheadSearch = createTypeaheadSearch { selectedTerm in
            searchSourceDelegate?.didUpdateSearchTerm(selectedTerm)
        }
        let (generalSearch, generalSearchSourceDelegate) = createGeneralSearch(typeaheadController: typeaheadSearch)
        searchSourceDelegate = generalSearchSourceDelegate
        return generalSearch
    }
    
    private func createGeneralSearch(typeaheadController: GeneralSearchUIComposer.SearchResultController) -> (UIViewController, GeneralSearchSourceDelegate) {
        let service = GeneralSearchService(baseURL: baseURL, httpClient: httpClient)
        let (generalSearch, generalSearchSourceDelegate) = GeneralSearchUIComposer.searchComposedWith(
            searchResultController: typeaheadController,
            searchLoader: service.makeRemoteGeneralSearchLoader,
            onEpisodeSelect: { episode in
                self.startPlayback(episode: episode)
                self.openPlayer()
            },
            onPodcastSelect: { _ in }
        )
        return (generalSearch, generalSearchSourceDelegate)
    }
    
    private func createTypeaheadSearch(onTermSelect: @escaping (String) -> Void) -> TypeaheadListViewController {
        let service = TypeaheadSearchService(baseURL: baseURL, httpClient: httpClient)
        return TypeaheadSearchUIComposer.searchComposedWith(
            searchLoader: service.makeRemoteTypeaheadSearchLoader,
            onTermSelect: onTermSelect
        )
    }
    
    private func startPlayback(episode: Episode) {
        let podcast = PodcastDetails(
            id: UUID().uuidString,
            title: "TITLE",
            publisher: "PUBLISHER",
            language: "English",
            type: .episodic,
            image: URL(string: "https://any-url.com")!,
            episodes: [], description: "Descrption", totalEpisodes: 1
        )
        audioPlayer.startPlayback(fromURL: episode.audio, withMeta: Meta(episode, podcast))
    }
    
    private func createPlayer() -> LargeAudioPlayerViewController {
        let service = EpisodeThumbnailLoaderService(
            httpClient: httpClient,
            podcastsImageDataStore: PodcastsImageDataStoreContainer.shared.podcastsImageDataStore
        )
        
        let largePlayerController = LargeAudioPlayerUIComposer.playerWith(
            statePublisher: audioPlayerStatePublisher,
            controlsDelegate: audioPlayer,
            imageLoader: service.makeRemotePodcastImageDataLoader(for:)
        )
        return largePlayerController
    }
}
