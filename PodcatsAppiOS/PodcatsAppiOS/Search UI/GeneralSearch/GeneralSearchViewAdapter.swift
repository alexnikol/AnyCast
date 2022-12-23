// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedComponentsiOSModule
import Combine
import LoadResourcePresenter
import SearchContentModule
import SearchContentModuleiOS
import PodcastsModule
import PodcastsModuleiOS

final class GeneralSearchViewAdapter: ResourceView {
    typealias ResourceViewModel = GeneralSearchContentResultViewModel
    
    weak var controller: ListViewController?
    private let onEpisodeSelect: (Episode) -> Void
    private let onPodcastSelect: (SearchResultPodcast) -> Void
    
    init(controller: ListViewController,
         onEpisodeSelect: @escaping (Episode) -> Void,
         onPodcastSelect: @escaping (SearchResultPodcast) -> Void) {
        self.controller = controller
        self.onEpisodeSelect = onEpisodeSelect
        self.onPodcastSelect = onPodcastSelect
    }
    
    func display(_ viewModel: ResourceViewModel) {
        let episodesCells = viewModel.episodes.map { episode in
            let episodeViewModel = GeneralSearchContentPresenter.map(episode)
            return EpisodeCellController(
                viewModel: episodeViewModel,
                selection: { [weak self] in
                    self?.onEpisodeSelect(episode)
                }
            )
        }
        let episodesSection = DefaultSectionWithNoHeaderAndFooter(cellControllers: episodesCells)
        
        let podcastsCells = viewModel.podcasts.map { podcast in
            let podcastViewModel = GeneralSearchContentPresenter.map(podcast)
            return SearchResultPodcastCellController(
                model: podcastViewModel,
                thumbnailViewController: ThumbnailUIComposer
                    .composeThumbnailWithImageLoader(
                        thumbnailURL: podcast.image,
                        imageLoader: { _ in Empty().eraseToAnyPublisher() }
                    ),
                selection: { [weak self] in
                    self?.onPodcastSelect(podcast)
                }
            )
        }
        let podcastsSection = DefaultSectionWithNoHeaderAndFooter(cellControllers: podcastsCells)
        
        let curatedListsSections: [SectionController] = viewModel.curatedLists.map { curatedList in
            let podcastsCells = curatedList.podcasts.map { podcast in
                let podcastViewModel = GeneralSearchContentPresenter.map(podcast)
                return SearchResultPodcastCellController(
                    model: podcastViewModel,
                    thumbnailViewController: ThumbnailUIComposer
                        .composeThumbnailWithImageLoader(
                            thumbnailURL: podcast.image,
                            imageLoader: { _ in Empty().eraseToAnyPublisher() }
                        ),
                    selection: { [weak self] in
                        self?.onPodcastSelect(podcast)
                    }
                )
            }
            return DefaultSectionWithNoHeaderAndFooter(cellControllers: podcastsCells)
        }
        
        let sections: [SectionController] = [episodesSection, podcastsSection] + curatedListsSections
        controller?.display(sections)
    }
}
