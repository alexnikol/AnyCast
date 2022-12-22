// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedComponentsiOSModule
import Combine
import LoadResourcePresenter
import SearchContentModule
import SearchContentModuleiOS
import PodcastsModuleiOS

final class GeneralSearchViewAdapter: ResourceView {
    typealias ResourceViewModel = GeneralSearchContentResultViewModel
    
    weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ResourceViewModel) {
        let episodesCells = viewModel.episodes.map { episode in
            let episodeViewModel = GeneralSearchContentPresenter.map(episode)
            return EpisodeCellController(viewModel: episodeViewModel, selection: {})
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
                selection: {}
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
                    selection: {}
                )
            }
            return DefaultSectionWithNoHeaderAndFooter(cellControllers: podcastsCells)
        }
        
        let sections: [SectionController] = [episodesSection, podcastsSection] + curatedListsSections
        controller?.display(sections)
    }
}
