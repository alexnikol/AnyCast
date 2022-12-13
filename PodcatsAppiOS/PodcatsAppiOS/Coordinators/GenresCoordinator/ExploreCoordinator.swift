// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import CoreData
import HTTPClient
import PodcastsModule
import PodcastsGenresList
import AudioPlayerModule
import AudioPlayerModuleiOS

class PodcastsImageDataStoreContainer {
    static let shared = PodcastsImageDataStoreContainer()
    
    lazy var podcastsImageDataStore: PodcastsImageDataStore = {
        try! CoreDataPodcastsImageDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("best-podcasts-image-data-store.sqlite")
        )
    }()
}

final class ExploreCoordinator {
    private let navigationController: UINavigationController
    private let baseURL: URL
    private let httpClient: HTTPClient
    private let localGenresLoader: LocalGenresLoader
    private let audioPlayer: AudioPlayer
    private let audioPlayerStatePublisher: AudioPlayerStatePublisher
    private var largePlayerController: LargeAudioPlayerViewController?
        
    init(navigationController: UINavigationController,
         baseURL: URL,
         httpClient: HTTPClient,
         localGenresLoader: LocalGenresLoader,
         audioPlayer: AudioPlayer,
         audioPlayerStatePublisher: AudioPlayerStatePublisher) {
        self.navigationController = navigationController
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localGenresLoader = localGenresLoader
        self.audioPlayer = audioPlayer
        self.audioPlayerStatePublisher = audioPlayerStatePublisher
    }
        
    func start() {
        navigationController.setViewControllers([createGenres()], animated: false)
    }
    
    private func show(screen: UIViewController) {
        self.navigationController.pushViewController(screen, animated: true)
    }
    
    private func present(screen: UIViewController) {
        self.navigationController.showDetailViewController(screen, sender: self)
    }
    
    private func createGenres() -> UIViewController {
        let genresLoaderService = GenresLoaderService(
            baseURL: baseURL,
            httpClient: httpClient,
            localGenresLoader: localGenresLoader
        )
        return GenresUIComposer.genresComposedWith(
            loader: genresLoaderService.makeLocalGenresLoaderWithRemoteFallback,
            selection: { genre in
                let bestPodcasts = self.createBestPodcasts(byGenre: genre)
                self.show(screen: bestPodcasts)
            }
        )
    }
    
    private func createBestPodcasts(byGenre genre: Genre) -> UIViewController {
        let bestPodcastsService = BestPodcastsService(
            baseURL: baseURL,
            httpClient: httpClient,
            podcastsImageDataStore: PodcastsImageDataStoreContainer.shared.podcastsImageDataStore
        )
        return BestPodcastsUIComposer.bestPodcastComposed(
            genreID: genre.id,
            podcastsLoader: bestPodcastsService.makeBestPodcastsRemoteLoader,
            imageLoader: bestPodcastsService.makeLocalPodcastImageDataLoaderWithRemoteFallback(for:),
            selection: { podcast in
                let podcastDetails = self.createPodcastDetails(
                    byPodcast: podcast,
                    selection: { [weak self] episode, podcast in
                        guard let self = self else { return }
                        
                        let player = self.openPlayerFor(episode: episode, podcast: podcast)
                        self.present(screen: player)
                    }
                )
                self.show(screen: podcastDetails)
            }
        )
    }
    
    private func createPodcastDetails(byPodcast podcast: Podcast, selection: @escaping (_ episode: Episode, _ podcast: PodcastDetails) -> Void) -> UIViewController {
        let podcastDetailsService = PodcastDetailsService(
            baseURL: baseURL,
            httpClient: httpClient,
            podcastsImageDataStore: PodcastsImageDataStoreContainer.shared.podcastsImageDataStore
        )
        return PodcastDetailsUIComposer.podcastDetailsComposedWith(
            podcastID: podcast.id,
            podcastsLoader: podcastDetailsService.makeRemotePodcastDetailsLoader,
            imageLoader: podcastDetailsService.makeRemotePodcastImageDataLoader(for:),
            selection: selection
        )
    }
    
    private func openPlayerFor(episode: Episode, podcast: PodcastDetails) -> LargeAudioPlayerViewController {
        audioPlayer.startPlayback(fromURL: episode.audio, withMeta: Meta(episode, podcast))
        
        guard largePlayerController == nil else {
            return largePlayerController!
        }
        
        let service = EpisodeThumbnailLoaderService(
            httpClient: httpClient,
            podcastsImageDataStore: PodcastsImageDataStoreContainer.shared.podcastsImageDataStore
        )
        
        let largePlayerController = LargeAudioPlayerUIComposer.playerWith(
            thumbnailURL: episode.thumbnail,
            statePublisher: audioPlayerStatePublisher,
            controlsDelegate: audioPlayer,
            imageLoader: service.makeRemotePodcastImageDataLoader(for:)
        )
        self.largePlayerController = largePlayerController
        return largePlayerController
    }
}