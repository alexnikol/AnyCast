// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedComponentsiOSModule
import Combine
import LoadResourcePresenter
import SearchContentModule
import SearchContentModuleiOS

final class GeneralSearchViewAdapter: ResourceView {
    typealias ResourceViewModel = GeneralSearchContentResultViewModel
    
    weak var controller: ListViewController?
    private let generalSearchPresenter: GeneralSearchContentPresenter
    private let onEpisodeSelect: (SearchResultEpisode) -> Void
    private let onPodcastSelect: (SearchResultPodcast) -> Void
    
    init(controller: ListViewController,
         generalSearchPresenter: GeneralSearchContentPresenter,
         onEpisodeSelect: @escaping (SearchResultEpisode) -> Void,
         onPodcastSelect: @escaping (SearchResultPodcast) -> Void) {
        self.controller = controller
        self.generalSearchPresenter = generalSearchPresenter
        self.onEpisodeSelect = onEpisodeSelect
        self.onPodcastSelect = onPodcastSelect
    }
    
    func display(_ viewModel: ResourceViewModel) {
        let episodesSection = makeEpisodesSection(viewModel.episodes)
        let podcastsSection = makePodcastsSection(viewModel.podcasts)
        let curatedListsSections: [SectionController] = viewModel.curatedLists.map(makeCuratedListSection)
        
        var sections: [SectionController] = []
        if !episodesSection.cellControllers.isEmpty {
            sections.append(episodesSection)
        }
        if !podcastsSection.cellControllers.isEmpty {
            sections.append(podcastsSection)
        }
        sections.append(contentsOf: curatedListsSections)
        controller?.display(sections)
    }
    
    private func makeEpisodesSection(_ episodes: [SearchResultEpisode]) -> SectionController {
        let episodesCells = episodes.map { episode in
            let episodeViewModel = generalSearchPresenter.map(episode)
            return SearchEpisodeCellController(
                viewModel: episodeViewModel,
                selection: { [weak self] in
                    self?.onEpisodeSelect(episode)
                }
            )
        }
        return TitleHeaderViewCellController(
            cellControllers: episodesCells,
            viewModel: TitleHeaderViewModel(
                title: GeneralSearchContentPresenter.episodesTitle
            )
        )
    }
    
    private func makePodcastsSection(_ podcasts: [SearchResultPodcast]) -> SectionController {
        let podcastsCells = podcasts.map { podcast in
            let podcastViewModel = generalSearchPresenter.map(podcast)
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
        return TitleHeaderViewCellController(
            cellControllers: podcastsCells,
            viewModel: TitleHeaderViewModel(
                title: GeneralSearchContentPresenter.podcastsTitle
            )
        )
    }
    
    private func makeCuratedListSection(_ curatedList: SearchResultCuratedList) -> SectionController {
        let podcastsCells = curatedList.podcasts.map { podcast in
            let podcastViewModel = generalSearchPresenter.map(podcast)
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
        return TitleHeaderViewCellController(
            cellControllers: podcastsCells,
            viewModel: TitleHeaderViewModel(
                title: curatedList.titleOriginal,
                description: curatedList.descriptionOriginal
            )
        )
    }
}
