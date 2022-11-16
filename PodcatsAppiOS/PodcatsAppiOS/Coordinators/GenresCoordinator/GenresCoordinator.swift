// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import HTTPClient
import PodcastsModule
import PodcastsGenresList

final class GenresCoordinator {
    private let navigationController: UINavigationController
    private let baseURL: URL
    private let httpClient: HTTPClient
    
    private let genresLoaderService: GenresLoaderService
    private let bestPodcastsService: BestPodcastsService
    private let podcastDetailsService: PodcastDetailsService
    
    init(navigationController: UINavigationController,
         baseURL: URL,
         httpClient: HTTPClient,
         localGenresLoader: LocalGenresLoader) {
        self.navigationController = navigationController
        self.baseURL = baseURL
        self.httpClient = httpClient
        bestPodcastsService = BestPodcastsService(baseURL: baseURL, httpClient: httpClient)
        podcastDetailsService = PodcastDetailsService(baseURL: baseURL, httpClient: httpClient)
        genresLoaderService = GenresLoaderService(
            baseURL: baseURL,
            httpClient: httpClient,
            localGenresLoader: localGenresLoader
        )
    }
    
    func start() {
        navigationController.setViewControllers([createGenres()], animated: false)
    }
    
    private func show(screen: UIViewController) {
        self.navigationController.pushViewController(screen, animated: true)
    }
    
    private func createGenres() -> UIViewController {
        return GenresUIComposer.genresComposedWith(
            loader: genresLoaderService.makeLocalGenresLoaderWithRemoteFallback,
            selection: { genre in
                let bestPodcasts = self.createBestPodcasts(byGenre: genre)
                self.show(screen: bestPodcasts)
            }
        )
    }
    
    private func createBestPodcasts(byGenre genre: Genre) -> UIViewController {
        BestPodcastsUIComposer.bestPodcastComposed(
            genreID: genre.id,
            podcastsLoader: bestPodcastsService.makeBestPodcastsRemoteLoader,
            imageLoader: bestPodcastsService.makeLocalPodcastImageDataLoaderWithRemoteFallback(for:),
            selection: { podcast in
                let podcastDetails = self.createPodcastDetails(byPodcast: podcast)
                self.show(screen: podcastDetails)
            }
        )
    }
    
    private func createPodcastDetails(byPodcast podcast: Podcast) -> UIViewController {
        PodcastDetailsUIComposer.podcastDetailsComposedWith(
            podcastID: podcast.id,
            podcastsLoader: podcastDetailsService.makeRemotePodcastDetailsLoader,
            imageLoader: podcastDetailsService.makeRemotePodcastImageDataLoader(for:)
        )
    }
}
