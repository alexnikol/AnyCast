// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import PodcastsModule
import PodcastsModuleiOS
import LoadResourcePresenter

final class PodcastDetailsViewAdapter: ResourceView {
    typealias ResourceViewModel = PodcastDetailsViewModel
    
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    private var cancellable: AnyCancellable?
    private let episodesPresenter = EpisodesPresenter()
    weak var controller: ListViewController?
    
    init(controller: ListViewController, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: PodcastDetailsViewModel) {
        let episodeCellControllers = viewModel.episodes.map({ episode -> EpisodeCellController in
            let episodeViewModel = episodesPresenter.map(episode)
            return EpisodeCellController(viewModel: episodeViewModel)
        })
        
        let sections = [
            PodcastHeaderCellController(
                cellControllers: episodeCellControllers,
                viewModel: viewModel
            )
        ]
        controller?.display(sections)
        controller?.title = viewModel.title
    }
    
    private struct InvalidImageData: Error {}
}
